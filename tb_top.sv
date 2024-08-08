`timescale 1ns / 1ps

module tb_top;

  // Inputs
  reg clk;
  reg reset_n;
  reg [18:0] instr_mem_rd_data_i;
  reg [18:0] data_mem_rd_data_i;

  // Outputs
  wire instr_mem_req_o;
  wire [18:0] instr_mem_addr_o;
  wire data_mem_req_o;
  wire [18:0] data_mem_addr_o;
  wire [1:0] data_mem_byte_en_o;
  wire data_mem_wr_o;
  wire [18:0] data_mem_wr_data_o;

  // Instantiate the Unit Under Test (UUT)
  top uut (
    .clk(clk),
    .reset_n(reset_n),
    .instr_mem_req_o(instr_mem_req_o),
    .instr_mem_addr_o(instr_mem_addr_o),
    .instr_mem_rd_data_i(instr_mem_rd_data_i),
    .data_mem_req_o(data_mem_req_o),
    .data_mem_addr_o(data_mem_addr_o),
    .data_mem_byte_en_o(data_mem_byte_en_o),
    .data_mem_wr_o(data_mem_wr_o),
    .data_mem_wr_data_o(data_mem_wr_data_o),
    .data_mem_rd_data_i(data_mem_rd_data_i)
  );

    // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

 

  // Stimulus process
  initial begin
    // Initialize Inputs
    reset_n = 0;
    instr_mem_rd_data_i = 19'h1ABCD;
    data_mem_rd_data_i = 19'h11460;
    

    // Wait for global reset to finish
    #10;
    reset_n = 1;

    $display("Starting test...");

    // Set initial instruction address
    //instr_mem_addr_o = 19'h0;
    data_mem_rd_data_i =19'h12345;
    // Test R-type instruction
    // [func7[2:0], rs1[2:0], rs2[2:0], func3[2:0], rd[2:0], opcode[3:0]]

    // Test for OP_ADD
    instr_mem_rd_data_i = 19'b101_010_011_000_010_0001;   // op_add
    data_mem_rd_data_i =19'h12346;
    #10;

    // Increment instruction address
    //instr_mem_addr_o = instr_mem_addr_o + 1;
    
    // Test for OP_SUB
    instr_mem_rd_data_i = 19'b101_010_011_001_010_0001;   // op_sub
    data_mem_rd_data_i =19'h12247;
    #10;

    // Increment instruction address
    //instr_mem_addr_o = instr_mem_addr_o + 1;
    

    // Test for OP_MUL
    instr_mem_rd_data_i = 19'b101_010_011_001_010_0001;
  //  instr_mem_rd_data_i = 19'b101_010_011_010_010_0001;   // op_mul
    data_mem_rd_data_i =19'h12248;
    #10;

    // Increment instruction address
   // instr_mem_addr_o = instr_mem_addr_o + 1;

    // Continue testing other instructions similarly
    // ...

    // Test for OP_DIV
    instr_mem_rd_data_i = 19'b101_010_011_011_010_0001;   // op_div
    data_mem_rd_data_i =19'h12348;
    #10;
   // instr_mem_addr_o = instr_mem_addr_o + 1;
   

    // Test for OP_INC
    instr_mem_rd_data_i = 19'b101_010_011_100_010_0001;   // op_inc
    data_mem_rd_data_i =19'h12349;
    #10;
   // instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_DEC
    instr_mem_rd_data_i = 19'b101_010_011_101_010_0001;   // op_dec
    data_mem_rd_data_i =19'h1234A;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_OR
    instr_mem_rd_data_i = 19'b101_010_011_011_110_0001;   // op_or
    data_mem_rd_data_i =19'h1234B;
    #10;
   // instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_AND
    instr_mem_rd_data_i = 19'b101_010_011_111_010_0001;   // op_and
    data_mem_rd_data_i =19'h1234B;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_XOR
    instr_mem_rd_data_i = 19'b111_010_011_000_010_0001;   // op_xor
    data_mem_rd_data_i =19'h1234C;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_NOT
    instr_mem_rd_data_i = 19'b111_010_011_001_010_0001;   // op_not
    data_mem_rd_data_i =19'h1234D;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_SLL
    instr_mem_rd_data_i = 19'b111_010_011_100_010_0001;   // op_sll
    data_mem_rd_data_i =19'h1234E;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_SRL
    instr_mem_rd_data_i = 19'b111_010_011_101_010_0001;   // op_srl
    data_mem_rd_data_i =19'h1234F;
    #10;
  //  instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_SRA
    instr_mem_rd_data_i = 19'b111_010_011_110_010_0001;   // op_sra
    data_mem_rd_data_i =19'h12350;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for OP_SLT
    instr_mem_rd_data_i = 19'b101_010_011_111_010_0001;   // op_slt
    data_mem_rd_data_i =19'h12351;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;
    
    // Continue with other instruction tests...
    
    // Example for data memory request
   // data_mem_addr_o = 19'h50;
   // data_mem_req_o = 1;
   // data_mem_wr_o = 0; // Read operation
   // #10;

    // Test for LB
    instr_mem_rd_data_i = 19'b000_000_000_001_010_0110; // LB
    data_mem_rd_data_i =19'h12352;
    #10;
   // instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for LBU
    instr_mem_rd_data_i = 19'b000_000_000_010_100_0110; // LBU
    data_mem_rd_data_i =19'h12353;
    #10;
   // instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for LH
    instr_mem_rd_data_i = 19'b000_000_000_011_110_0110; // LH
    data_mem_rd_data_i =19'h12354;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Test for LW
    instr_mem_rd_data_i = 19'b000_000_000_100_000_0110; // LW
    data_mem_rd_data_i =19'h12355;
    #10;
    //instr_mem_addr_o = instr_mem_addr_o + 1;

    // Continue with other load/store instructions...

    // Example for writing to data memory
   // data_mem_wr_o = 1; // Write operation
    //data_mem_wr_data_o = 19'h12345;
    //data_mem_byte_en_o = 2'b11; // Byte enable for the whole word
    //#10;
    
    // Continue with additional tests...

    // Finish the test
    $display("Test completed.");
    $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %d, Instr Addr: %h, Data Addr: %h, Instr Mem Req: %b, Data Mem Req: %b",
             $time, instr_mem_addr_o, data_mem_addr_o, instr_mem_req_o, data_mem_req_o);
  end
endmodule





  

