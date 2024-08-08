`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2024 15:20:28
// Design Name: 
// Module Name: pc_reg
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

module pc_reg (
    input logic clk,
    input logic reset_n,
    input logic [2:0] instr_func3_ctl_i,
    input logic branch_taken,
    input logic is_b_type_ctl_i,
    input logic [18:0] data_i,
    input logic ctl_pc_sel,
    output logic [18:0] pc_q,
    output logic [18:0] sp_q
);

  parameter RESET_PC = 19'h100;
  logic branch_taken_o;
  logic reset_seen_q;
  logic [18:0] sp_nxt, nxt_pc;
  logic [18:0] stack [0:511]; // Stack memory for CALL/RET instructions
  logic [18:0] nxt_seq_pc;    // Next sequential PC
  logic [18:0] pc_o;
  logic [18:0] sp_o;

  // Capture the first cycle out of reset
  always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
          reset_seen_q <= 1'b0;
      end else begin
          reset_seen_q <= 1'b1;
      end
  end

  // Sequential logic for stack pointer
  always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
          sp_q <= 19'h10100;
      end else begin
          sp_q <= sp_nxt;
      end
  end

  // Sequential logic for program counter
  always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
          pc_q <= RESET_PC;
      end else begin
          pc_q <= nxt_pc;
      end
  end

  // Compute next sequential PC
  assign nxt_seq_pc = pc_q + 19'h4;

  // Compute the next PC based on control signals
  always_comb begin
      sp_nxt = sp_q; // Default value for stack pointer
      nxt_pc = nxt_seq_pc; // Default value for next PC

      if (is_b_type_ctl_i) begin
          case (instr_func3_ctl_i)
              3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111: begin
                  // Branch instructions handled here
                  if (branch_taken_o) begin
                      nxt_pc = {data_i[18:1], 1'b0}; // Set PC to branch address
                  end
              end
              3'b010: begin // CALL
                  sp_nxt = sp_q - 19'h4; // Decrement stack pointer
                  stack[sp_q] = pc_q + 19'h4; // Store return address in the stack
                  nxt_pc = data_i; // Set next PC value to the call address
              end
              3'b011: begin // RET
                  sp_nxt = sp_q + 19'h4; // Increment stack pointer
                  nxt_pc = stack[sp_q]; // Set next PC value from the stack
              end
              default: begin 
                  sp_nxt = sp_q; 
                  nxt_pc = nxt_seq_pc; 
              end
          endcase
      end else begin 
          sp_nxt = sp_q; // Default value for stack pointer
          nxt_pc = nxt_seq_pc; // Default value for next PC
      end

      branch_taken_o = branch_taken | ctl_pc_sel;
  end

  assign pc_o = pc_q;
  assign sp_o = sp_q;

endmodule
