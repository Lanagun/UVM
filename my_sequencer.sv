// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_sequencer.sv
// Create : 2020-05-24 15:56:04
// Revise : 2020-05-24 15:56:28
// Editor : sublime text3, tab size (4)
// Describe: my_sequencer是一个参数化的类，其参数是my_transaction,
//			 表明这个sequencer只能产生my_transaction类型的数据
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequencer extends uvm_sequencer #(my_transaction);
//Component
	extern function new( string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	//Register
	 `uvm_component_utils(my_sequencer)
 endclass

 function my_sequencer::new(string name, uvm_component parent);
 	super.new(name, parent);
 endfunction // new

 function void my_sequencer::build_phase(uvm_phase phase);
 	super.build_phase(phase);
 endfunction

 task my_sequencer::main_phase(uvm_phase phase);
	my_sequence my_seq;
	super.main_phase(phase);
	my_seq = new("my_seq");
	my_seq.starting_phase = phase;
	my_seq.start(this);				//与my_env中的main_phase关于启动sequence的部分参数不一样而已
endtask