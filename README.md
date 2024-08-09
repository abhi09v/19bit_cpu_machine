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

Design Requirements
The design requirements for the decode unit is similar to the instruction fetch. It would take the instruction as an input and give all of the above information as we discussed as output.

Interface Definition
The decode unit would have the following interface definition:

instr_i : 32-bit instruction to be encoded
rs1_o : 5-bit value giving the first source register
rs2_o : 5-bit value giving the second source register
rd_o : 5-bit value giving the destination register
op_o : 7-bit signal for the instruction opcode
funct3_o : The 3-bits instruction function
funct7_o : The 7-bits instruction function
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
