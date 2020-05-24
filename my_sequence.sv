// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_sequence.sv
// Create : 2020-05-24 17:47:18
// Revise : 2020-05-24 17:47:18
// Editor : sublime text3, tab size (4)
// Describe:  my_sequence派生自objection，start（在my_env中调用）被调用后，my_seq的body开始执行，于是开始发送数据。
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence extends uvm_sequence #(my_transaction);  // my_sequence 是参数化的类，其参数为my_transaction
	my_transaction m_trans;

	extern function new(string name = "my_sequence");
	virtual task body();					//body 是关键
		if(starting_phase != null)
			starting_phase.raise_objection(this);
		repeat (10) begin
			`uvm_do(m_trans)		//这是一个宏，这个宏每执行一次就会向uvm_sequencer发送一个数据
									//end这是一个宏，这个宏每执行一次就会向uvm_sequencer发送一个数据
									//当在driver中调用seq_item_port的item_done方法后，一次uvm_do宏执行完毕，
									//进入下一次uvm_do宏的执行中。当所有的uvm_do执行完毕后，driver的
									//seq_item_port的get_next _item方法就接收不到任何数据，会一直等待（阻塞）在那里。
		#100;
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask

	`uvm_object_utils(my_sequence)
endclass

function my_sequence::new(string name= "my_sequence");
	super.new(name);
endfunction // new