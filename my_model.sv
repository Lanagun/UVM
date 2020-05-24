// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_model.sv
// Create : 2020-05-24 16:38:06
// Revise : 2020-05-24 16:38:06
// Editor : sublime text3, tab size (4)
// Describe: reference model是整个验证平台的核心。在reference model中使用uvm_blocking_get_port来获得agent发送来的数据。
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_model extends uvm_component;

	uvm_blocking_get_port #(my_transaction) port;  //它与uvm_analysis_port一样，同样是TLM通信的一种端口。它用于接收一个uvm_analysis_port发送的信息，而uvm_analysis_port是发送信息的。
	uvm_analysis_port #(my_transaction) ap;			// 用于把reference model的输出结果发送给scoreboard。
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);

	`uvm_component_utils(my_model)
endclass // my_model

function my_model::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction // new

function void my_model::build_phase(uvm_phase phase);    //主要四一些实例化
	super.build_phase(phase);
	port = new("port", this);
	ap = new("ap", this);
endfunction // build_phase

task my_model::main_phase(uvm_phase phase);		 //包含一些具体操作
	my_transaction tr;
	super.main_phase(phase);
	while(1) begin
		port.get(tr);				// DUT比较简单，只是把数据转发，没有做任何工作，因此这里的main_phase在30行接收到一个transaction后，
									// 31行直接未做处理把这个transaction发送出去。
		ap.write(tr);
	end
endtask
