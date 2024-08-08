`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2024 16:53:27
// Design Name: 
// Module Name: regfiles
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile (
  input   logic          clk,
  input   logic          reset_n,

  // Source 8 registers
  input   logic [2:0]    rs1_addr_i,
  input   logic [2:0]    rs2_addr_i,

  // Destination register
  input   logic [2:0]    rd_addr_i,
  input   logic          wr_en_i,
  input   logic [18:0]   wr_data_i,

  // Register Data
  output  logic [18:0]   rs1_data_o,
  output  logic [18:0]   rs2_data_o
);

  // --------------------------------------------------------
  // Internal Wires and Registers
  // --------------------------------------------------------
  // Register File
  logic [6:0] [18:0]regfile;

  // --------------------------------------------------------
  // Write logic for the register file
  // --------------------------------------------------------
  for (genvar i=0; i<8; i++) begin : g_regfile_wr
    logic reg_wr_en;
    // Enable the flops only for the register being written
    assign reg_wr_en = (rd_addr_i[2:0] == i[2:0]) & wr_en_i;
    // Flops for the register file
    always_ff @(posedge clk)
      // Register X0 is hardwired to '0
      if (i==0) begin
        regfile[i] <= 19'h0;
      end else begin
        if(reg_wr_en) begin
          regfile[i] <= wr_data_i;
        end
      end
      
  end

  // --------------------------------------------------------
  // Read logic for the register file
  // --------------------------------------------------------
  assign rs1_data_o = regfile[rs1_addr_i];
  assign rs2_data_o = regfile[rs2_addr_i];

endmodule
