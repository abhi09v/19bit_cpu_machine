`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2024 14:57:32
// Design Name: 
// Module Name: packages
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2024 13:40:21
// Design Name: 
// Module Name: package
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


package pkgs;

  typedef enum logic[3:0] {
    R_TYPE    = 4'h1,
    I_TYPE_0  = 4'h3,
    I_TYPE_1  = 4'h6,
    I_TYPE_2  = 4'h9,
    S_TYPE    = 4'hA,
    B_TYPE    = 4'hC,
    U_TYPE_0  = 4'h4,
    U_TYPE_1  = 4'h7,
    J_TYPE    = 4'hF
  } riscv_op_t;
 
  // ALU Op Types
  typedef enum logic[3:0] {
    OP_ADD = 4'b0000,
    OP_SUB = 4'b0001,
    OP_MUL = 4'b0010,
    OP_DIV = 4'b0011,
    OP_INC = 4'b0100,
    OP_DEC = 4'b0101,
    OP_OR  = 4'b0110,
    OP_AND = 4'b0111,
    OP_XOR = 4'b1000,
    OP_NOT = 4'b1001,
    OP_SLL = 4'b1011,
    OP_SRL = 4'b1100,
    OP_SRA = 4'b1101,
    OP_SLT = 4'b1110
  } alu_op_t;

  // Memory Access Width
  typedef enum logic[1:0] {
    BYTE      = 2'b00,
    HALF_WORD = 2'b01,
    WORD      = 2'b11
  } mem_access_size_t;

  // R Type
  // Formed using {funct7[1],funct3}
  typedef enum logic[3:0] {
    ADD   = 4'h0,
    SUB   = 4'h7,
    MUL   = 4'h6,
    DIV   = 4'h1,
    INC   = 4'h2,
    DEC   = 4'h3,
    OR    = 4'hD,
    AND   = 4'h5,
    XOR   = 4'h8,
    NOT   = 4'h4,
    SLL   = 4'h9,
    SLT   = 4'hA
  } r_type_t;

  // I Type
  // Formed using {opcode[1:0],1'b0, funct3}
  typedef enum logic[5:0] {
    LB    = 6'h2A,
    LBU   = 6'h2B,
    LH    = 6'h2C,
    LW    = 6'h2D,
    
    MULI  = 6'h38,
    DIVI  = 6'h39,
    INCI  = 6'h30,
    DECI  = 6'h31,
    ORI   = 6'h32,
    ANDI  = 6'h33,
    XORI  = 6'h34,
    NOTI  = 6'h35,   
    ADDI  = 6'h36,
    SUBI  = 6'h37,
    
    FFTI  =  6'h10,
    ENCRYPTI = 6'h11,
    DECRYPTI = 6'h12
  } i_type_t;


  // S Type
  typedef enum logic[2:0] {
    SB = 3'h0,
    SH = 3'h1,
    SW = 3'h2
  } s_type_t;

  // B Type
  typedef enum logic[2:0] {
    BEQ  = 3'h0,
    BNE  = 3'h1,
    BLT  = 3'h4,
    BGE  = 3'h5,
    BLTU = 3'h6,
    BGEU = 3'h7
  } b_type_t;




  // U Type
  typedef enum logic[3:0] {
    AUIPC = 4'h4,
    LUI   = 4'h7
  } u_type_t;

  // J Type
  typedef enum logic[3:0] {
    JAL = 4'hF
  } j_type_t;


  // Control signals
  typedef struct packed {
    logic       data_req;
    logic       data_wr;
    logic [1:0] data_byte;
    logic       zero_extnd;
    logic       rf_wr_en;
    logic       pc_sel;
    logic       op1_sel;
    logic       op2_sel;
    logic [1:0] rf_wr_data_sel;
    logic [3:0] alu_funct_sel;
  } control_t;

  typedef enum logic[1:0] {
    ALU = 2'b00,
    MEM = 2'b01,
    IMM = 2'b10,
    PC  = 2'b11
  } rf_wr_data_src_t;
  
   typedef enum logic[2:0] {
    DATA_MEM      = 3'b000,
    FFT           = 3'b010,
    ENCRYPT        = 3'b101,
    DECRYPT        = 3'b111   
  } custom_instr_t;
  
  
   typedef enum logic[1:0] {
    SP      = 2'b00,
    RET     = 2'b01,
    CALL    = 2'b10 
  } subroutine_t;
  
endpackage

