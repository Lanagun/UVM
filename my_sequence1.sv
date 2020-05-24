// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_sequence1.sv
// Create : 2020-05-24 21:53:33
// Revise : 2020-05-24 21:57:41
// Editor : sublime text3, tab size (4)
// Describe: 
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence1 extends uvm_sequence #(my_transaction);
	my_transaction m_trans;

	extern function new(string name = "my_sequence1");
	virtual task body();
		if(starting_phase != null)
			 starting_phase.raise_objection(this);
		 repeat (10) begin
			 `uvm_do_with(m_trans, { m_trans.pload.size() == 60;})
		 end
		 #100;
		 if(starting_phase != null)
		 	starting_phase.drop_objection(this);
	 endtask

 	`uvm_object_utils(my_sequence1)
 endclass

 function my_sequence1::new(string name= "my_sequence1");
	 super.new(name);
 endfunction // new

 class my_case1 extends my_test;
 	extern function new(string name = "my_case1", uvm_component parent = null);
 	extern virtual function void build_phase(uvm_phase phase);
	 `uvm_component_utils(my_case1)
 endclass

 function my_case1::new(string name = "my_case1", uvm_component parent = null);
 	super.new(name,parent);
	$display("SHORT_SEQ::NEW");
 endfunction // new

 function void my_case1::build_phase(uvm_phase phase);
 	super.build_phase(phase);

 	uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", my_sequence1::type_id::get());
 endfunction