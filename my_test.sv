// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_test.sv
// Create : 2020-05-24 21:53:23
// Revise : 2020-05-24 21:53:24
// Editor : sublime text3, tab size (4)
// Describe: 
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_test extends uvm_test;

	my_env env;
	extern function new(string name = "my_test", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	`uvm_component_utils(my_test)
 endclass

 function my_test::new(string name = "my_test", uvm_component parent = null);
	 super.new(name,parent);
	 env = new("env", this);
 endfunction

 function void my_test::build_phase(uvm_phase phase);
 	super.build_phase(phase);
 endfunction



 class my_case0 extends my_test;
	 extern function new(string name = "my_case0", uvm_component parent = null);
	 extern virtual function void build_phase(uvm_phase phase);
	 `uvm_component_utils(my_case0)
 endclass

 function my_case0::new(string name = "my_case0", uvm_component parent = null);
 	super.new(name,parent);
 endfunction // new

 function void my_case0::build_phase(uvm_phase phase);
 	super.build_phase(phase);

 	uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", my_sequence::type_id::get());
 	// 通知env.i_agt.sqr，让其在运行到main_phase时自动启动前面定义的my_sequence。这里就是sequence的自动启动了。
 	// 通过config_db的set方式，让sequencer自动启动sequence是一个比较好的选择.
 endfunction