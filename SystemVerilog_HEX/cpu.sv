

`include "alucodes.sv"
module cpu #( parameter n = 8) // data bus width
(input logic clk,  
  input logic [9:0] SW,  // 10 Switches: Reset, trigger, inputs;
  output logic[n-1:0] LED // need an output port, tentatively this will be the ALU output
);       

// declarations of local signals that connect CPU modules
// ALU
logic [1:0] ALUfunc; // ALU function
 
logic imm; // immediate operand signal
logic [n-1:0] Alub; // output from imm MUX
//
// registers
logic [n-1:0] Rdata1, Rdata2, Wdata; // Register data
logic w; // register write control
//
// Program Counter 
parameter Psize = 4; // up to 16 instructions
logic PCincr; // program counter control
logic [Psize-1 : 0]ProgAddress;
// Program Memory
parameter Isize = 15; // Isize - instruction width
logic [Isize:0] I; // I - instruction code

logic immSW;


//------------- code starts here ---------
// module instantiations
pc  #(.Psize(Psize)) progCounter (.clk(clk),.reset(SW[9]),
        .PCincr(PCincr),
        .PCout(ProgAddress) );

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.address(ProgAddress),.I(I));

decoder  D (.opcode(I[Isize-1:Isize-6]),
            .PCincr(PCincr),
             
		  .ALUfunc(ALUfunc),.imm(imm),.w(w), .sw8(SW[8]), .immSW(immSW));

regs   #(.n(n))  gpr(.clk(clk),.w(w),
        .Wdata(Wdata),
		.Raddr2(I[7:0]),  
		.Raddr1(I[9:8]), 
		.Waddr1(I[9:8]),
		
        .Rdata1(Rdata1),.Rdata2(Rdata2));

alu    #(.n(n))  iu(.a(Rdata1),.b(Alub),
       .func(ALUfunc),
       .result(Wdata)); // ALU result -> destination reg

// create MUX for immediate operand

assign Alub = imm ?(immSW ? SW[7:0] : I[7:0]):Rdata2;


// connect ALU result to outport
assign LED = Wdata;

endmodule
