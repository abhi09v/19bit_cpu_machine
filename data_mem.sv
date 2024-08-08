<<<<<<< HEAD
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2024 01:22:03
// Design Name: 
// Module Name: data_mem
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



module data_mem import pkgs::*; (
  input   logic           clk,
  input   logic           reset_n,

  // Data request from current instruction
  input   logic           data_req_i,
  input   logic [18:0]    data_addr_i,
  input   logic [1:0]     data_byte_en_i,
  input   logic           data_wr_i,
  input   logic [18:0]    data_wr_data_i,
  input logic [2:0]       custom_instr_i,      
   input   logic           data_zero_extnd_i,

  // Read/Write request to memory
  output  logic           data_mem_req_o,
  output  logic  [18:0]   data_mem_addr_o,
  output  logic  [1:0]    data_mem_byte_en_o,
  output  logic           data_mem_wr_o,
  output  logic  [18:0]	  data_mem_wr_data_o,
  // Read data from memory
  input   logic [18:0]    mem_rd_data_i,

  // Data output
  output  logic [18:0]    data_mem_rd_data_o
);

  // --------------------------------------------------------
  // Internal signals
  // --------------------------------------------------------
  logic [18:0] data_mem_rd_data;
  logic [18:0] rd_data_sign_extnd;
  logic [18:0] rd_data_zero_extnd;

  // Memory read data contains the data to be used for the operation
  assign rd_data_sign_extnd = (data_byte_en_i == HALF_WORD) ? {{3{mem_rd_data_i[15]}}, mem_rd_data_i[15:0]}  :
                              (data_byte_en_i == BYTE)      ? {{11{mem_rd_data_i[7]}},  mem_rd_data_i[7:0]}   :
                                                                                        mem_rd_data_i;

  assign rd_data_zero_extnd = (data_byte_en_i == HALF_WORD) ? {{3{1'b0}}, mem_rd_data_i[15:0]}  :
                              (data_byte_en_i == BYTE)      ? {{11{1'b0}}, mem_rd_data_i[7:0]}   :
                                                                           mem_rd_data_i;
  // Mux between zero or sign extended data
  assign data_mem_rd_data = data_zero_extnd_i ? rd_data_zero_extnd : rd_data_sign_extnd;
  
  
      
  // --------------------------------------------------------
  // Output assignments
  // --------------------------------------------------------
  assign data_mem_req_o     = data_req_i;
  assign data_mem_addr_o    = data_addr_i;
  assign data_mem_byte_en_o = data_byte_en_i;
  assign data_mem_wr_o      = data_wr_i;
  assign data_mem_wr_data_o = data_wr_data_i;
  assign data_mem_rd_data_o = data_mem_rd_data;



=======
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2024 01:22:03
// Design Name: 
// Module Name: data_mem
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



module data_mem import pkgs::*; (
  input   logic           clk,
  input   logic           reset_n,

  // Data request from current instruction
  input   logic           data_req_i,
  input   logic [18:0]    data_addr_i,
  input   logic [1:0]     data_byte_en_i,
  input   logic           data_wr_i,
  input   logic [18:0]    data_wr_data_i,

  input   logic           data_zero_extnd_i,

  // Read/Write request to memory
  output  logic           data_mem_req_o,
  output  logic  [18:0]   data_mem_addr_o,
  output  logic  [1:0]    data_mem_byte_en_o,
  output  logic           data_mem_wr_o,
  output  logic  [18:0]	  data_mem_wr_data_o,
  // Read data from memory
  input   logic [18:0]    mem_rd_data_i,

  // Data output
  output  logic [18:0]    data_mem_rd_data_o
);

  // --------------------------------------------------------
  // Internal signals
  // --------------------------------------------------------
  logic [18:0] data_mem_rd_data;
  logic [18:0] rd_data_sign_extnd;
  logic [18:0] rd_data_zero_extnd;

  // Memory read data contains the data to be used for the operation
  assign rd_data_sign_extnd = (data_byte_en_i == HALF_WORD) ? {{3{mem_rd_data_i[15]}}, mem_rd_data_i[15:0]}  :
                              (data_byte_en_i == BYTE)      ? {{11{mem_rd_data_i[7]}},  mem_rd_data_i[7:0]}   :
                                                                                        mem_rd_data_i;

  assign rd_data_zero_extnd = (data_byte_en_i == HALF_WORD) ? {{3{1'b0}}, mem_rd_data_i[15:0]}  :
                              (data_byte_en_i == BYTE)      ? {{11{1'b0}}, mem_rd_data_i[7:0]}   :
                                                                           mem_rd_data_i;
  // Mux between zero or sign extended data
  assign data_mem_rd_data = data_zero_extnd_i ? rd_data_zero_extnd : rd_data_sign_extnd;

  // --------------------------------------------------------
  // Output assignments
  // --------------------------------------------------------
  assign data_mem_req_o     = data_req_i;
  assign data_mem_addr_o    = data_addr_i;
  assign data_mem_byte_en_o = data_byte_en_i;
  assign data_mem_wr_o      = data_wr_i;
  assign data_mem_wr_data_o = data_wr_data_i;

  assign data_mem_rd_data_o = data_mem_rd_data;



>>>>>>> ca6d96d69d3511b1200923fd6440e830558c4363
endmodule