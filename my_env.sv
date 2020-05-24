// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_env.sv
// Create : 2020-05-24 17:06:27
// Revise : 2020-05-24 17:06:27
// Editor : sublime text3, tab size (4)
// Describe: UVM验证平台中可以使用uvm_tlm_analysis_fifo把uvm_blocking_get_port和uvm_ analysis_port连接。
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
	my_agent i_agt;
	my_agent o_agt;
	my_model mdl;
	my_scoreboard scb;
	//当一个ap写入数据时，有两种可能，一是uvm_blocking_get_port正在等待接收数据（如scoreboard的32和36行所示）
	//这种情况下，ap.write()可以马上返回；二是uvm_blocking_get_port没有等待数据，在这种情况下一般就是uvm_blocking_get_port所在
	//的uvm_component正在处理别的事情，无暇从uvm_blocking_get_port获得数据。在这种情况下，ap.write的行为会是怎么样呢？
	//为了应对这种情况，有必要在uvm_blocking_get_port和ap之间连接一个fifo.
	uvm_tlm_analysis_fifo #(my_transaction) agt_scb_fifo;
	uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;
	uvm_tlm_analysis_fifo #(my_transaction) mdl_scb_fifo;

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	`uvm_component_utils(my_env)
endclass

function my_env::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction // new

function void my_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	i_agt = new("i_agt", this);
	o_agt = new("o_agt", this);
	i_agt.is_active = UVM_ACTIVE;
	o_agt.is_active = UVM_PASSIVE;
	mdl = new("mdl", this);
	scb = new("scb", this);
	agt_scb_fifo = new("agt_scb_fifo", this);
	agt_mdl_fifo = new("agt_mdl_fifo", this);
	mdl_scb_fifo = new("mdl_scb_fifo", this);
endfunction // build_phase

function void my_env::connect_phase(uvm_phase phase);
	super.build_phase(phase);
	i_agt.ap.connect(agt_mdl_fifo.analysis_export);		//analysis_export 发送端
	mdl.port.connect(agt_mdl_fifo.blocking_get_export);   //blocking_get_export 是scoreboard的接收端
	mdl.ap.connect(mdl_scb_fifo.analysis_export);
	scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
	o_agt.ap.connect(agt_scb_fifo.analysis_export);
	scb.act_port.connect(agt_scb_fifo.blocking_get_export);
endfunction

// 下面这部分可以启动sequence
task my_env::main_phase(uvm_phase phase);
	my_sequence my_seq;
	super.main_phase(phase);
	my_seq = new("my_seq");
	my_seq.starting_phase = phase;		//输入参数送给starting_phase
	my_seq.start(i_agt.sqr);			//start 函数应该是my_sequence父类（uvm_sequence）的方法，在build_phase 例化
										//i_agt.sqr 这个参数指明这个sequence会向哪个sequencer发送数据
endtask : main_phase