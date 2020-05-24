// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : my_if.sv
// Create : 2020-05-24 15:07:21
// Revise : 2020-05-24 15:09:12
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
interface my_if(input logic rxc, input logic txc);

  logic [7:0] rxd;
  logic rx_dv;
  
  logic [7:0] txd;
  logic tx_en;
  
  // from model to dut
   clocking drv_cb @(posedge rxc);
     output #1 rxd, rx_dv;
   endclocking
  
   clocking mon_cb @(posedge txc);
     input #1 txd, tx_en;
   endclocking // tx_cb

 endinterface // my_if