// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_scoreboard.sv
// Create : 2020-05-24 16:52:46
// Revise : 2020-05-24 16:52:46
// Editor : sublime text3, tab size (4)
// Describe: scoreboard中一般使用一个队列来暂存从reference model得到的期望数据。
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_scoreboard extends uvm_scoreboard;
	my_transaction expect_queue[$];
	uvm_blocking_get_port #(my_transaction) exp_port;
	uvm_blocking_get_port #(my_transaction) act_port;
	`uvm_component_utils(my_scoreboard)
	 extern function new(string name, uvm_component parent = null);
	 extern virtual function void build_phase(uvm_phase phase);
	 extern virtual task main_phase(uvm_phase phase);
 endclass

 function my_scoreboard::new(string name, uvm_component parent = null);
 	super.new(name, parent);
 endfunction

 function void my_scoreboard::build_phase(uvm_phase phase);
	 super.build_phase(phase);
	 exp_port = new("exp_port", this);
	 act_port = new("act_port", this);
 endfunction

task my_scoreboard::main_phase(uvm_phase phase);
	my_transaction get_expect, get_actual, tmp_tran;
	bit result;

	super.main_phase(phase);
	fork
		while (1) begin
			 exp_port.get(get_expect);
			 expect_queue.push_back(get_expect);
		end
		while (1) begin
			act_port.get(get_actual);
			 if(expect_queue.size() > 0) begin
				tmp_tran = expect_queue.pop_front();
				result = get_actual.compare(tmp_tran);  //这里比较用到了compare函数，这里之所以可以用这个函数比较，
														//是因为在定义transaction时，使用了一系列的uvm_field_*宏。
														//compare将会逐字段比较get_actual和tmp_tran，如果所有的字
														//段都一样，那么返回1，否则返回0。
				if(result) begin
				 	$display("Compare SUCCESSFULLY");
				end
			 	else begin
					$display("Compare FAILED");
					$display("the expect pkt is");
					tmp_tran.print();
					$display("the actual pkt is");
					get_actual.print();
		 		end
		 	end
			else begin
				$display("ERROR::Received from DUT, while Expect Queue is empty");
				get_actual.print();
			end
	 	end
	join
endtask
