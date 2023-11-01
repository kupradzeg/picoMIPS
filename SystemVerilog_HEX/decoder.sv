

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decoder
( input logic [4:0] opcode, // top 5 bits of instruction

// output signals
//    PC control
output logic PCincr,
//    ALU control
output logic [1:0] ALUfunc, 
// imm mux control
output logic imm,
//   register file control
input logic sw8, //sw8 trigger
//Flag to read from switches
output logic immSW, 
//write control
output logic w

  );
   
//------------- code starts here ---------
// instruction decoder
always_comb 
begin
  // set default output signal values
   PCincr = 1'b1; // PC increments by default
   ALUfunc = opcode[1:0]; //set first 2 bits of opcode to ALUfunc
   imm=1'b0; 
   immSW = 1'b0;
   w = 1'b1;
   
   case(opcode)
	  
     `IMM: begin
	 
		imm = 1'b1;
	 
	 end  
     `SWI: begin 
	        PCincr = sw8;

			
			imm = 1'b1;
			immSW = 1'b1;
			
	      end
		  
     `ADD:;
	 
	 `ADDI: begin
			imm =1'b1;  
	  end	  
	  `MUL:;
	  
	  `MULI: begin
			imm = 1'b1;
	  end 
	  `ST_0: begin
		PCincr = ~sw8;
		w = 1'b0;
		
	  end
	  `ST_1: begin
			PCincr = sw8;
			w = 1'b0;
	  end

	 	  

	default:
	    $error("unimplemented opcode %h",opcode);
 
  endcase // opcode
  


end // always_comb


endmodule //module decoder --------------------------------