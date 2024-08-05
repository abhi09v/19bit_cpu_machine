`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2024 23:02:39
// Design Name: 
// Module Name: execute
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




module execute import pkgs::*; (
  // Source operands
  input   logic [18:0] opr_a_i,
  input   logic [18:0] opr_b_i,

  // ALU Operation
  input   logic [3:0]  op_sel_i,

  // ALU output
  output  logic [18:0] alu_res_o
);

  // --------------------------------------------------------
  // Internal wire and regs
  // --------------------------------------------------------
  logic [18:0] twos_compl_a;
  logic [18:0] twos_compl_b;

  logic [18:0] alu_res;

  assign twos_compl_a = opr_a_i[18] ? ~opr_a_i + 19'h01 : opr_a_i;
  assign twos_compl_b = opr_b_i[18] ? ~opr_b_i + 19'h01 : opr_b_i;

  always_comb begin
    case (op_sel_i)
      OP_ADD  : alu_res = opr_a_i + opr_b_i;
      OP_SUB  : alu_res = opr_a_i - opr_b_i;
      OP_MUL  : alu_res = opr_a_i * opr_b_i;
      OP_DIV  : alu_res = opr_a_i / opr_b_i;
      OP_INC  : alu_res = alu_res + 19'b1;
      OP_DEC  : alu_res = alu_res - 19'b1;
      // (opr_a_i >> opr_b_i[4:0]) | ({32{opr_a_i[31]}} & ~(32'hFFFFFFFF>>opr_b_i[4:0]));
      OP_OR   : alu_res = opr_a_i | opr_b_i;
      OP_AND  : alu_res = opr_a_i & opr_b_i;
      OP_XOR  : alu_res = opr_a_i ^ opr_b_i;
      OP_NOT  : alu_res = ~opr_a_i ;
      default : alu_res = 19'h0;
    endcase
  end

  assign alu_res_o = alu_res;

endmodule