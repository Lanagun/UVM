// -----------------------------------------------------------------------------
// Copyright (c) 2020-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : LLG    liaolianggang@gmail.com
// File   : DUT.sv
// Create : 2020-05-24 15:07:04
// Revise : 2020-05-24 15:07:05
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module dut (clk,
            rxd,
            rx_dv,
            txd,
            tx_en);
input clk;
input [7:0] rxd;
input rx_dv;
output [7:0] txd;
output tx_en;
reg [7:0] txd;
reg tx_en;
always @(posedge clk) begin
         txd <= rxd;
         tx_en <= rx_dv;
end
endmodule