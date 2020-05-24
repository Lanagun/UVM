// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_driver.sv
// Create : 2020-05-24 15:07:32
// Revise : 2020-05-24 15:07:35
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
include "uvm_macros.svh"
import uvm_pkg::*;

class my_driver extends uvm_driver #(my_transaction);
  virtual my_if vif;
  uvm_analysis_port #(my_transaction) ap;
  
  `uvm_component_utils(my_driver)
  
   extern function new (string name, uvm_component parent);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
   extern task drive_one_pkt(my_transaction req);
   extern task drive_one_byte(bit [7:0] data);
 endclass

 function my_driver::new (string name, uvm_component parent);
   super.new(name, parent);
 endfunction

 function void my_driver::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(virtual my_if)::get(this, "", "my_if", vif))  // 对应在top中有set
     `uvm_fatal("my_driver", "Error in Getting interface");
   ap = new("ap", this);
 endfunction
 
 task my_driver::main_phase(uvm_phase phase); 
   my_transaction req;
   super.main_phase(phase);
   vif.drv_cb.rxd <= 0;
   vif.drv_cb.rx_dv <= 1'b0;
   while(1) begin
     seq_item_port.get_next_item(req);  //申请得到一个my_transaction 类型的item，driver如果想要发送数据就要从这个端口中获得，这个方法是my_driver父类（uvm_driver）的方法
     drive_one_pkt(req);
     ap.write(req);
     seq_item_port.item_done();
   end
 endtask
 
 task my_driver::drive_one_pkt(my_transaction req);
   byte unsigned data_q[];   //双状态，8比特有符号整数，取值范围为-128~127
   int data_size;			//双状态，32位有符号整数
   data_size = req.pack_bytes(data_q) / 8;   //调用pack_bytes函数，这里之所以能使用pack_bytes函数，是因为我们之前在定义my_transaction时使用了uvm_field_*一系列宏，
   											 //pack_bytes把48位的dmac分成6份，按照设置的大小端格式，把这6份放入data_q中。放完了dmac后，再放smac，真正到把crc放完后为止。
   											 //这里放的顺序就是按照uvm_field_*宏的书写顺序。在上面的例子中，crc的uvm_field宏是最后写的，所以这里就会被放在最后面。
   repeat(3) @vif.drv_cb;
   for ( int i = 0; i < data_size; i++ ) begin
     drive_one_byte(data_q[i]); // drive data pattern
   end
   @vif.drv_cb;
   vif.drv_cb.rx_dv <= 1'b0;
 endtask

 task my_driver::drive_one_byte(bit [7:0] data);
   @vif.drv_cb;
   vif.drv_cb.rxd <= data;
   vif.drv_cb.rx_dv <= 1'b1;
 endtask