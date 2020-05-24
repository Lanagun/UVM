// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_agent.sv
// Create : 2020-05-24 16:03:22
// Revise : 2020-05-24 16:22:28
// Editor : sublime text3, tab size (4)
// Describe: UVM验证平台中的agent实现了driver，monitor和sequencer的封装，agent是整个验证平台中唯一直接与DUT的
// 			 物理接口打交道的组件。一个agent的行为主要是由其封装的driver，monitor和sequencer实现，所以agent的main_phase
//			 一般不写任何内容。agent最重要的是其build_phase和connect_phase。
// -----------------------------------------------------------------------------
class my_agent extends uvm_agent ;
	 my_sequencer sqr;
	 my_driver drv;
	 my_monitor mon;

	 extern function new(string name, uvm_component parent);
	 extern virtual function void build_phase(uvm_phase phase);
	 extern virtual function void connect_phase(uvm_phase phase);

	 uvm_analysis_port#(my_transaction) ap;

	 `uvm_component_utils_begin(my_agent)
		 `uvm_field_object ( sqr , UVM_ALL_ON)
		 `uvm_field_object ( drv , UVM_ALL_ON)
		 `uvm_field_object ( mon , UVM_ALL_ON)
	`uvm_component_utils_end
endclass // my_agent

function my_agent::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction // new

// my_agent的关键在于build_phase,通过is_active的值来实例化不同的成员变量
// is_active用来形容这个agent所扮演的角色,当一个agent要驱动总线时，它会实例化一个driver，
// 这种情况下就是UVM_ACTIVE;在i_agent中，它只需要负责向DUT发送数据，同时把发送的数据复制一份发送给reference即可，所以它是UVM_ACTIVE的。
// 而在o_agent中，只是负责监测DUT的输出，所以它不需要实例化driver，是UVM_PASSIVE的。
function void my_agent::build_phase(uvm_phase phase);		
	super.build_phase(phase);
if (is_active == UVM_ACTIVE) begin
	sqr = my_sequencer::type_id::create("sqr", this);
	drv = my_driver::type_id::create("drv", this);
end
else begin
	mon = my_monitor::type_id::create("mon", this);
end
endfunction // build_phase

function void my_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if (is_active == UVM_ACTIVE) begin
		drv.seq_item_port.connect(sqr.seq_item_export);
		//seq_item_port这个方法是my_driver父类（uvm_driver）的方法,在my_driver 中使用過
		this.ap = drv.ap;
	end
	else begin
		this.ap = mon.ap;      				//connect_phase中把agent的ap指向monitor的ap。
	end
endfunction