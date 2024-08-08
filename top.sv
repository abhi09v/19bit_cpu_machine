`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2024 14:34:00
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module top import pkgs::*; #(
  parameter RESET_PC = 19'h100
)(
  input   logic          clk,
  input   logic          reset_n,

  // Instruction memory interface
  output  logic          instr_mem_req_o,
  output  logic [18:0]   instr_mem_addr_o,
  input   logic [18:0]   instr_mem_rd_data_i,

  // Data memory interface
  output  logic          data_mem_req_o,
  output  logic [18:0]   data_mem_addr_o,
  output  logic [1:0]    data_mem_byte_en_o,
  output  logic          data_mem_wr_o,
  output  logic [18:0]   data_mem_wr_data_o,
  input   logic [18:0]   data_mem_rd_data_i


);

  // --------------------------------------------------------
  // Internal signals
  // --------------------------------------------------------
  logic [18:0]  imem_dec_instr;
  logic [2:0]   dec_rf_rs1;
  logic [2:0]   dec_rf_rs2;
  logic [2:0]   dec_rf_rd;
  logic [18:0]  rf_rs1_data;
  logic [18:0]  rf_rs2_data;
  logic [18:0]  rf_wr_data;
  logic [18:0]  alu_opr_a;
  logic [18:0]  alu_opr_b;
  logic [18:0]  data_mem_rd_data;
  logic [18:0]  nxt_seq_pc;
  logic [18:0]  nxt_pc;
  logic [18:0]  pc_q;
  logic [3:0]   dec_ctl_opcode;
  logic [2:0]   dec_ctl_funct3;
  logic [2:0]   dec_ctl_funct7;
  logic         r_type_instr;
  logic         i_type_instr;
  logic         s_type_instr;
  logic         b_type_instr;
  logic         u_type_instr;
  logic         j_type_instr;
  logic         c_type_instr;
  logic [18:0]  dec_instr_imm;
  logic [3:0]   ctl_alu_func;  //Add sub mul 
  logic [18:0]  ex_alu_res;
  logic         ctl_pc_sel;
  logic         ctl_op1sel;
  logic         ctl_op2sel;
  logic         ctl_data_req;
  logic         ctl_data_wr;
  logic [1:0]   ctl_data_byte;
  logic [1:0]   ctl_rf_wr_data;  //4:1 mux
  logic         ctl_rf_wr_en;
  logic         ctl_zero_extnd;
  logic         branch_taken;
  logic         reset_seen_q;
  logic [2:0]    custom_instr;
  logic          pc_sel;
  logic [18:0]   sp_q;


/*  ifdef YARP_VAL
    logic [31:0] [31:0] regfile;
    assign regfile = u_yarp_regfile.regfile;
  endif   */ 

  // --------------------------------------------------------
  // Main logic
  // --------------------------------------------------------
  // Capture the first cycle out of reset


  // --------------------------------------------------------
  // Instruction Memory
  // --------------------------------------------------------
  instr_mem u_instr_mem (
    .clk                      (clk),
    .reset_n                  (reset_n),
    .instr_mem_pc_i           (pc_q),
    .instr_mem_req_o          (instr_mem_req_o),
    .instr_mem_addr_o         (instr_mem_addr_o),
    .mem_rd_data_i            (instr_mem_rd_data_i),
    .instr_mem_instr_o        (imem_dec_instr)
  );

pc_reg u_pc_reg(
    .clk                     (clk),
    .reset_n                 (reset_n),
    .instr_func3_ctl_i       (dec_ctl_funct3),
    .branch_taken            (branch_taken),
    .data_i                 (ex_alu_res),
    .ctl_pc_sel              (ctl_pc_sel),
    .pc_q                    (pc_q),
    .sp_q                    (nxt_seq_pc),
    .is_b_type_ctl_i         (b_type_instr)
);
  // --------------------------------------------------------
  // Instruction Decode
  // --------------------------------------------------------
  decode u_decode (
    .instr_i                  (imem_dec_instr),
    .rs1_o                    (dec_rf_rs1),
    .rs2_o                    (dec_rf_rs2),
    .rd_o                     (dec_rf_rd),
    .op_o                     (dec_ctl_opcode),
    .funct3_o                 (dec_ctl_funct3),
    .funct7_o                 (dec_ctl_funct7),
    .r_type_instr_o           (r_type_instr),
    .i_type_instr_o           (i_type_instr),
    .s_type_instr_o           (s_type_instr),
    .b_type_instr_o           (b_type_instr),
    .u_type_instr_o           (u_type_instr),
    .j_type_instr_o           (j_type_instr),
    .c_type_instr_o           (c_type_instr),
    .instr_imm_o              (dec_instr_imm)
  );

  // --------------------------------------------------------
  // Register File
  // --------------------------------------------------------
  // Register File write data
  assign rf_wr_data = (ctl_rf_wr_data == ALU) ? ex_alu_res :
                      (ctl_rf_wr_data == MEM) ? data_mem_rd_data :
                      (ctl_rf_wr_data == IMM) ? dec_instr_imm :
                                                nxt_seq_pc;
                                                      
  regfile u_regfile (
    .clk                      (clk),
    .reset_n                  (reset_n),
    .rs1_addr_i               (dec_rf_rs1),
    .rs2_addr_i               (dec_rf_rs2),
    .rd_addr_i                (dec_rf_rd),
    .wr_en_i                  (ctl_rf_wr_en),
    .wr_data_i                (rf_wr_data),
    .rs1_data_o               (rf_rs1_data),
    .rs2_data_o               (rf_rs2_data)
  );

  // --------------------------------------------------------
  // Control Unit
  // --------------------------------------------------------
  control u_control (
    .instr_funct3_i           (dec_ctl_funct3),
    .instr_funct7_bit1_i      (dec_ctl_funct7[1]),
    .instr_opcode_i           (dec_ctl_opcode),
    .is_r_type_i              (r_type_instr),
    .is_i_type_i              (i_type_instr),
    .is_s_type_i              (s_type_instr),
    .is_b_type_i              (b_type_instr),
    .is_u_type_i              (u_type_instr),
    .is_j_type_i              (j_type_instr),
    .is_c_type_i              (c_type_instr),
    .pc_sel_o                 (ctl_pc_sel),
    .op1_sel_o                 (ctl_op1sel),
    .op2_sel_o                 (ctl_op2sel),
    .data_req_o               (ctl_data_req),
    .data_wr_o                (ctl_data_wr),
    .data_byte_o              (ctl_data_byte),
    .zero_extnd_o             (ctl_zero_extnd),
    .rf_wr_en_o               (ctl_rf_wr_en),
    .rf_wr_data_o             (ctl_rf_wr_data),
    .alu_func_o               (ctl_alu_func),
    .custom_instr_o            (custom_instr)
    
  );

  // --------------------------------------------------------
  // Branch Control
  // --------------------------------------------------------
  branch_control u_branch_control (
    .opr_a_i                  (rf_rs1_data),
    .opr_b_i                  (rf_rs2_data),
    .is_b_type_ctl_i          (b_type_instr),
    .instr_func3_ctl_i        (dec_ctl_funct3),
    .branch_taken_o           (branch_taken),
    .ctl_pc_sel                 (ctl_pc_sel)
  );

  // --------------------------------------------------------
  // Execute Unit
  // --------------------------------------------------------
  // ALU operand mux
  assign alu_opr_a_nxt = ctl_op1sel ? pc_q : rf_rs1_data;
  assign alu_opr_b_nxt = ctl_op2sel ? dec_instr_imm : rf_rs2_data;


assign alu_opr_a =  (|dec_instr_imm[2:0])  ? 19'h0 : alu_opr_a_nxt;
assign alu_opr_b =  (|dec_instr_imm[2:0]) ? alu_opr_b_nxt : 19'h0;
  execute u_execute (
    .opr_a_i                  (alu_opr_a),
    .opr_b_i                  (alu_opr_b),
    .op_sel_i                 (ctl_alu_func),
    .alu_res_o                (ex_alu_res)
  );

  // --------------------------------------------------------
  // Data Memory
  // --------------------------------------------------------
  data_mem u_data_mem (
    .clk                      (clk),
    .reset_n                  (reset_n),
    .data_req_i               (ctl_data_req),
    .data_addr_i              (ex_alu_res),
    .data_byte_en_i           (ctl_data_byte),
    .data_wr_i                (ctl_data_wr),
    .data_wr_data_i           (rf_rs2_data),
    .data_zero_extnd_i        (ctl_zero_extnd),
    .data_mem_req_o           (data_mem_req_o),
    .data_mem_addr_o          (data_mem_addr_o),
    .data_mem_byte_en_o       (data_mem_byte_en_o),
    .data_mem_wr_o            (data_mem_wr_o),
    .data_mem_wr_data_o       (data_mem_wr_data_o),
    .mem_rd_data_i            (data_mem_rd_data_i),
    .data_mem_rd_data_o       (data_mem_rd_data),
    .custom_instr_i             (custom_instr)
  );

// --------------------------------------------------------
  // custom instruction mux
  logic [18:0]fft_o;
  
    
  assign fft_i = ~(data_mem_rd_data[18:0]);
  assign encrypt_i = {14'b0,data_mem_rd_data[4:0]};
  assign decrypt_i = {14'b1,data_mem_rd_data[4:0]};
  
  assign fft_o = fft_i;
  logic [18:0]encrypt_o;
  assign encrypt_o = encrypt_i;
  logic [18:0]decrypt_o;
  assign decrypt_o = decrypt_i;

  
   assign data_mem_rd_data = (custom_instr == FFT)  ?  fft_o :
                            (custom_instr == ENCRYPT)? encrypt_o :
                            (custom_instr == DECRYPT)? decrypt_o :
                            data_mem_rd_data;


endmodule
