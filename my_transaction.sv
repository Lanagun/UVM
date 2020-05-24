// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_transaction.sv
// Create : 2020-05-24 15:07:44
// Revise : 2020-05-24 15:07:46
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_transaction extends uvm_sequence_item ;
  rand bit [47:0] dmac;
  rand bit [47:0] smac;
  rand bit [15:0] ether_type;
  rand byte pload[] ; // size should be configurable
  rand bit [31:0] crc;

 constraint cons_pload_size {
   pload.size >= 46;
   pload.size <= 1500;
 }
   extern function new (string name = "my_transaction");
   `uvm_object_utils_begin(my_transaction)
     `uvm_field_int(dmac, UVM_ALL_ON)
     `uvm_field_int(smac, UVM_ALL_ON)
     `uvm_field_int(ether_type, UVM_ALL_ON)
     `uvm_field_array_int(pload, UVM_ALL_ON)
     `uvm_field_int(crc, UVM_ALL_ON)
   `uvm_object_utils_end
endclass // my_transaction

 function my_transaction::new(string name = "my_transaction");
   super.new(name);
 endfunction