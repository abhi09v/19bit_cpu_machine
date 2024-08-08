<<<<<<< HEAD
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2024 12:11:30
// Design Name: 
// Module Name: instr_mem
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


module instr_mem (
  input    logic          clk,
  input    logic          reset_n,

  input    logic [18:0]   instr_mem_pc_i,

  // Output read request to memory
  output   logic          instr_mem_req_o,
  output   logic [18:0]   instr_mem_addr_o,

  // Read data from memory
  input    logic [18:0]   mem_rd_data_i,

  // Instruction output
  output   logic [18:0]   instr_mem_instr_o
);

  // --------------------------------------------------------
  // Internal signals
  // --------------------------------------------------------
  logic instr_mem_req_q;

  // Assert valid always since the processor will need a new
  // instruction every cycle out from reset
  always_ff @(posedge clk or negedge reset_n)
    if (!reset_n)
      instr_mem_req_q <= 1'b0;
    else
      instr_mem_req_q <= 1'b1;

  assign instr_mem_req_o  = instr_mem_req_q;
  assign instr_mem_addr_o = instr_mem_pc_i;

  // Memory read data contains the instruction to be processed
  assign instr_mem_instr_o = mem_rd_data_i;

=======
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2024 12:11:30
// Design Name: 
// Module Name: instr_mem
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


module instr_mem (
  input    logic          clk,
  input    logic          reset_n,

  input    logic [18:0]   instr_mem_pc_i,

  // Output read request to memory
  output   logic          instr_mem_req_o,
  output   logic [18:0]   instr_mem_addr_o,

  // Read data from memory
  input    logic [18:0]   mem_rd_data_i,

  // Instruction output
  output   logic [18:0]   instr_mem_instr_o
);

  // --------------------------------------------------------
  // Internal signals
  // --------------------------------------------------------
  logic instr_mem_req_q;

  // Assert valid always since the processor will need a new
  // instruction every cycle out from reset
  always_ff @(posedge clk or negedge reset_n)
    if (!reset_n)
      instr_mem_req_q <= 1'b0;
    else
      instr_mem_req_q <= 1'b1;

  assign instr_mem_req_o  = instr_mem_req_q;
  assign instr_mem_addr_o = instr_mem_pc_i;

  // Memory read data contains the instruction to be processed
  assign instr_mem_instr_o = mem_rd_data_i;

>>>>>>> ca6d96d69d3511b1200923fd6440e830558c4363
endmodule