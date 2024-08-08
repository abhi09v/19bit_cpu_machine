`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2024 14:53:26
// Design Name: 
// Module Name: branch_control
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

module branch_control import pkgs::*; (
    // Source operands
    input logic [18:0] opr_a_i,
    input logic [18:0] opr_b_i,
    input logic clk,
    input logic reset_n,
    // Branch Type
    input logic is_b_type_ctl_i,
    input logic [2:0] instr_func3_ctl_i,
    input logic ctl_pc_sel,
    // Branch outcome
    output logic branch_taken_o
);

    // --------------------------------------------------------
    // Internal signals
    // --------------------------------------------------------
    logic [18:0] twos_compl_a;
    logic [18:0] twos_compl_b;
    logic branch_taken;
    
   

    // Compute two's complement for unsigned comparisons
    assign twos_compl_a = opr_a_i[18] ? ~opr_a_i + 19'h1 : opr_a_i;
    assign twos_compl_b = opr_b_i[18] ? ~opr_b_i + 19'h1 : opr_b_i;

    // Branch comparison logic
    always_comb begin
        case (instr_func3_ctl_i)
            4'h0: branch_taken = (opr_a_i == opr_b_i); // BEQ
            4'h1: branch_taken = (opr_a_i != opr_b_i); // BNE
            4'h2: branch_taken = (opr_a_i <  opr_b_i); // BLT
            4'h3: branch_taken = (opr_a_i >= opr_b_i); // BGE
            4'h4: branch_taken = (twos_compl_a <  twos_compl_b); // BLTU
            4'h5: branch_taken = (twos_compl_a >= twos_compl_b); // BGEU
            4'h6 :branch_taken = '1;   //call 
            4'h6 :branch_taken = '1;    //ret
            default: branch_taken = 1'b0;
        endcase
    end
 
 assign branch_taken_o = branch_taken;
   

  
endmodule
