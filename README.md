# Processor Design 

Author: Abhishek Verma

  <img src="final_cpu.png">

- Instruction Fetch
- Instruction Decode
- Register File
- Instruction Execute
- Data Memory
- Control
- Branch Control
- PC Reg
- Top

## Instruction Fetch
Before the processor can decode or execute an instruction, it needs to fetch (or simply get) the instruction from the memory. The binary encodings of the instructions are stored in the memory and the processor uses the program counter (an address to memory in other words) to read those instructions.

The processor would fetch a new instruction whenever it needs to. The modern processors usually fetch multiple instructions in one clock cycle for better performance. However, the YARP processor would request for one instruction only whenever it has completely processed the last instruction i.e. after every clock cycle.

### Design Requirements
In order to keep things simple, the memory returns data on the same cycle as the request. Since the YARP processor is single-cycle, this means that the instructions would be executed in one cycle and hence the processor can easily fetch a new instruction at the beginning of the next cycle.

### Interface Definition
The instruction fetch would have the following interface definition:

- instr_mem_pc_i : This input represents the current Program Counter value
- instr_mem_req_o : Outgoing request to the instruction memory
- instr_mem_addr_o : Outgoing address from where the instruction should be fetched
- mem_rd_data_i : Icoming read data from the instruction memory
- instr_mem_instr_o : Outgoing instruction to the decode stage
- Apart from the instr_mem_req_o signal all the other inputs and outputs would be 32-bit wide. The instr_mem_req_o is a single bit output.

### Interface Requirement
- The instruction request must be asserted after YARP processor comes out of reset
- The instruction memory would respond back data on the same cycle which is why there's no ready signal associated with the interface

##  Instruction Decode
Every ISA defines the following for an instruction:

The length of the instruction (in our RISC-V processor every instruction is 32-bit wide)
The number of architectural registers instruction can access. These could be either source registers (which specify the data which the instruction would process) or the destination register (where the result of the operation would be stored)
The operation which the instruction should perform. Add, subtract, shifting, multiplication are different example of these operations
Few other sideband signals - these would be used to allow the processor to decode these instructions easily All the above information is usually contained within the instruction (this is what the 32-bits of the instruction covers).
The RISC-V ISA broadly defines 6 instruction formats, namely:

- R-type
- I-type
- S-type
- B-type
- U-type
- J-type
- C-type
  
Each of the above formats further have various instructions defined within. For example R-type contains instructions like ADD, AND, OR, etc. These formats have their own way of encoding the various information (source and destination registers, immediate values (if any) and sideband signals). Here's a snippet of the various instruction encodings from the RISC-V ISA: InstructionFormats

A quick description of what these encodings mean:

- opcode : This is the sideband signal which is used to decide one of the instruction format
- rd : One of the X0-X31 reigsters used as the destination where the result of the instruction would be stored
- rs1 : One of the X0-X31 registers used as one of data sources for the instruction
- rs2 : One of the X0-X31 registers used as the other data source for the instruction
- funct3/funct7 : Sideband signals used for further decoding instruction within one of the instruction formats
- imm : This contains the immediate value to be processed by the instruction. Should be 0 for R-type
With this we can now start looking at the design of a decode engine for our RISC-V processor. This unit would get the input from the instruction fetch unit, decode it and send various information about the instruction to rest of the parts of the processor.

### Design Requirements
The design requirements for the decode unit is similar to the instruction fetch. It would take the instruction as an input and give all of the above information as we discussed as output.

### Interface Definition
The decode unit would have the following interface definition:

- instr_i : 19-bit instruction to be encoded
- rs1_o : 3-bit value giving the first source register
- rs2_o : 3-bit value giving the second source register
- rd_o : 3-bit value giving the destination register
- op_o : 4-bit signal for the instruction opcode
- funct3_o : The 3-bits instruction function
- funct7_o : The 3-bits instruction function
- r_type_instr_o : Current instruction is an R-type instruction
- i_type_instr_o : Current instruction is an I-type instruction
- s_type_instr_o : Current instruction is an S-type instruction
- b_type_instr_o : Current instruction is an B-type instruction
- u_type_instr_o : Current instruction is an U-type instruction
- j_type_instr_o : Current instruction is an J-type instruction
- c_type_instr_o : Current instruction is an C-type instruction
- illegal_instr_o : Current instruction is an illegal instruction
- instr_imm_o : A 20-bit sign extended signal for the immediate value within the instruction
  
As you can see the decode unit would provide all the necessary information about the instruction. In fact, it even contains some extra information which tells the current instruction format. In the later tutorials all this information would be used by different blocks to simplify their design. For now let's get started designing the decode unit.

## Register File
the register file is used to read the value stored into one of the architectural registers and even to write the value to one of the architecture register. Here is the quick recap of the six instruction types as defined by the RISC-V ISA and the way those encode the source or destination registers:

### Instruction Type
	Source Register 1 (RS1)	Source Register 2 (RS2)	Destination Register (RD)

There are few instruction types which either don't read any source registers (U and J type) or don't write to the destination register (S and B type). The R-type instructions read the values from both the source register and write the result of the instruction to the destination register. The I-type instructions on the other hand just read the source register 1. The later tutorials would cover in-depth as to how these instruction compute their result. Other than the source and destination register it is also imperative to understand the length for each of the registers that would be implemented in the register file. The RISC-V ISA uses the term XLEN to denote the length of architectural registers present in the processor. For our processor the XLEN would be equal to 32, which means there are 32 registers, each of those would be 32-bit wide. Also, the RISC-V ISA mandates that the register 0 (X0) should be hardwired to 0 i.e. the register would always keep the value 0. Even if the instruction wants to write another value to X0, this value would be ignored and register X0 would continue to give the value 0. For more information, please refer to section "2.1 Programmers’ Model for Base Integer ISA" of the RISC-V ISA.


### Design Requirements
The register file should allow reading the values of two register and writing to one register and as from the above encodings it is clear that the register needs to support ports to allow reading two source registers and writing to one of the register. The instruction encodings above would serve as the addresses from where the data would be read/written to. The register file should ensure that the register X0 is hardwired to 0.

Since the processor is single-cycle, it should be fine to allow write to take a cycle but the read data should be given on the same cycle which would be later used to during the execute phase.

### Interface Definition
The register file would have the following interface definition:

- clk : Input clock signal (this is same as the processor clock)
- rs1_addr_i : 5-bit input address for the RS1 source register
- rs2_addr_i : 5-bit input address for the RS2 source register
- rd_addr_i : 5-bit input address for the RD destination register
- wr_en_i : 1-bit write enable signal input
- wr_data_i : 32-bit write data input
- rs1_data_o : 32-bit output data corresponding to RS1 register
- rs2_data_o : 32-bit output data corresponding to RS2 register

## ALU
The arithmetic logical unit is responsible for executing the function specified by the instruction. Looking into the RISC-V ISA, one could define the following operations which would be sufficient to execute most of the instructions as per the RV32I implementation. The table below list the various ALU operations and the corresponding RISC-V instructions from the RV32I Base Instruction Set:

### ALU Operation	Instructions
- Addition (+)	ADD, ADDI, LW, SW, JALR, AUIPC, JAL, Branches
- Subtraction (-)	SUB
- Shift left (<<)	SLL, SLLI
- Logical Shift right (>>)	SRL, SRLI
- Arithmetic Shift right(>>>)	SRA, SRAI
- Logical OR (|)	OR, ORI
- Logical AND (&)	AND, ANDI
= Logical XOR (^)	XOR, XORI

From the above table it is clear that the ALU would need to perform operations on two operands and drive the result as the output. The ALU would take in the two operands which could either be values read from the register file or the immediate value specified from within the instruction opcode. It would also take in the type of operation to be performed on those two operands before giving the result. This would be a good time to dig into the RISC-V ISA and learn more about the operation of the instructions listed above. To gain more familiarity please refer to section "2.4 Integer Computational Instructions" of the RISC-V ISA. The chapter describes the operation for the instructions listed above.

### Design Requirements
The ALU would be a pure combinational unit and would give out result in the same cycle. The ALU design should be straightforward with just a bit of care for the logic around the signed and unsigned operations.

### Interface Definition
The arithmetic unit would have the following interface definition:

- opr_a_i : 32-bit input. This is the first operand
- opr_b_i : 32-bit input. This is the second operand
- op_sel_i : 4-bit input signal to select ALU operation
- alu_res_o : 32-bit ALU result output
The operation select signal needs to be only 4-bit wide as the ALU can only get upto 10 various combinations of functions.

## Data Memory
The data memory is needed to read or write data generated by the processor to the memory. The data memory acts like a storage area where the processor can write data generated after performing a series of operation. The data can be also be retrived by performing the load instruction which reads the data from the memory at the specified address. The RISC-V ISA specifies various flavours of load and store instructions based on the size of the data which needs to read or written to the memory. The size of the memory operation can be classified into:

- Byte (8-bits)
- Half-word (16-bits)
- Word (32-bits)
Similarly, when reading data less than 19-bits, the RISC-ISA also specifies if the data needs to be sign-extended or zero extended to form the complete 32-bits which gets stored into the destination register.

### Data-Memory

Given all of the above, let's try to design the interface to the data memory keeping the above requirements.

### Interface Definition
The data memory would have the following interface definition

Data request interface from the current instruction:

- data_req_i : The current instruction needs to send request to data memory
- data_addr_i: The 32-bit address for the data memory
- data_byte_en_i: The 2-bit encoding for the access size. Must be defined as:
- 2'b00 : Byte Access
- 2'b01 : Half-word Access
- 2'b10 : Reserved
- 2'b11 : Word Access
- data_wr_i: This is a write request if asserted else it is a read request
- data_wr_data_i: The 32-bit write data
- data_zero_extnd_i: The read data should be zero extended if asserted else sign extended
- Data Memory interface

- data_mem_req_o: Request valid on this cycle
- data_mem_addr_o: 32-bit address for the data memory
- data_mem_byte_en_o: The 2-bit encoding for the access size
- data_mem_wr_o: Whether it is a write request or a read request to memory
- data_mem_wr_data_o: 32-bit write data with the write request
- mem_rd_data_i: 32-bit read data from the memory

- data_mem_rd_data_o: 32-bit read data as output from the yarp_data_mem module

### Design Requirements
- The request should be sent to the memory only for the instruction which need to access data memory
- The data memory would return the data on the same cycle as when the request is asserted
- As per the RISC-V ISA the address must be aligned to the access size of the transaction
- The data memory would return the data as per the access size starting at the LSB position
- The above implies that when a byte size access is made, the memory would return the byte at bits1:0 of mem_rd_data_i signal
- The data sent on the data_mem_rd_data_o output must be sign extended if data_zero_extnd_i is 0 otherwise it must be zero extended to form the complete 19-bit data

##  Control Unit

- What are the sources of the operands for the instruction? These can be either the two source registers, the immediate vector from the instruction, the current program counter or a combination of these.
- What operation must the ALU perform on the two operands? This would drive the op_sel_i input to the ALU
- Whether the instruction writes into the destination register? This would assert the write enable signal to the reigster file
- If the current instruction needs to access the memory and also whether it is a read or a write access. Along with this what is the access size of the current request.
- Whether the read data from the memory needs to be zero extended or sign extended?
- Whether the next program counter is the next sequential PC or the target address from a jump or a branch instruction?
- As you can see the control instruction produces all of these signals as outputs and can help decide the next state of the processor. It would be good to review the supported instruction from Chapter 25 of the RISC-V ISA. Also, read about the operation performed by each instruction from section 2.4, 2.5 and 2.6 of the RISC-V ISA.

### YARP-Control

### Interface Definition
The control unit would have the following interface definition:

The current instruction type:

- is_r_type_i: The current instruction is of R-type
- is_i_type_i: The current instruction is of I-type
- is_s_type_i: The current instruction is of S-type
- is_b_type_i: The current instruction is of B-type
- is_u_type_i: The current instruction is of U-type
- is_j_type_i: The current instruction is of J-type
- is_c_type_i: The current instruction is of C-type

The instruction opcode and function fields:

- instr_funct3_i: 3-bit funct3 field associated with the instruction
- instr_funct7_bit1_i: bit1 from the funct7 field of the instruction
= instr_opcode_i: 7-bit opcode field from the instruction
= Control signals

- pc_sel_o : The mux select for the next PC value
0: Next sequential PC
1: Branch/Jump target PC
- op1sel_o : The mux select for source operand 1
0: RS1 read data
1: Current Program Counter
= op2sel_o : The mux select for source operand 2
0: RS2 read data
1: Instruction immediate
  - alu_func_o : The 4-bit operation type for the ALU
As per the defined enum
- rf_wr_en_o : The write enable for the register file
0: Instruction doesn't writes to RF
1: Instruction writes to RF
- rf_wr_data_o : The 2-bit mux select for the register file write data
00: Pick ALU output as RF write data
01: Pick read data from data memory as RF write data
10: Pick the 32-bit instruction immediate as RF write data
11: Pick the next sequential PC as RF write data
- data_req_o : Request valid for the data memory
- data_byte_o : The request access size for data memory
As per the defined enum
- data_wr_o : Write or a read request for data memory
- zero_extnd_o : Zero extend read data from data memory
### Design Requirements
- The control unit must generate all of the control signals in the same cycle
- For illegal / non-supported instruction the control units must be 0

### Branch Control
Before looking into the design requirements of the branch control unit, it is important to understand the various branch type instructions. Please read the section 2.5 of the ISA which details the control transfer instruction with a focus on the "Conditional Branches" section. This would help decide the various operation which must be supported by the control unit for the conditional branches. Upon reading the section, it would be clear that the following operations must be supported:

- BEQ: Branch if source operand 1 and 2 are equal
- BNE: Branch if source operand 1 and 2 are not equal
- BLT: Branch if source operand 1 is less than source operand 2
- BGE: Branch if source operand 1 is greater than or equal to source operand 2
- BLTU: Branch if unsigned source operand 1 is less than unsigned source operand 2
- BGEU: Branch if unsigned source operand 1 is greater than or equal to unsigned source operand 2

- CALL : Branch to immediate instruction and save the Current  PC to Stack
- RET : 

Interface Definition
The branch control unit would have the following interface definition:

- opr_a_i: Source operand 1
- opr_b_i: Source operand 2
- is_b_type_ctl: If the current instruction is of B-type
- instr_func3_ctl_i: The 3-bit funct3 value of the instruction
- branch_taken_o: Whether the conditional branch is taken
### Design Requirements
- The control unit must generate all of the control signals in the same cycle
-The branch_taken output must be 0 for non branch instructions

