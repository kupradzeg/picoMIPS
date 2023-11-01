//-----------------------------------------------------
// File Name : regs.sv
// Function : picoMIPS 32 x n registers, %0 == 0
// Version 1 :
// Author: tjk
// Last rev. 27 Oct 2012
//-----------------------------------------------------
module regs #(parameter n = 8) // n - data bus width
(input logic clk, w, // clk and write control
 input logic [n-1:0] Wdata,
 input logic [7:0] Raddr2,
 input logic [1:0] Raddr1,
 input logic [1:0] Waddr1,
 output logic [7:0] Rdata1,
 output logic [n-1:0] Rdata2);

 	// Declare registers 
	logic [n-1:0] gpr [3:0];

	
	// write process
	always_ff @ (posedge clk)
	begin
		if(w)	
         gpr[Waddr1] <= Wdata;

	end
	//read process
	always_comb
	begin		

        Rdata1 = gpr[Raddr1];

		Rdata2 = gpr[Raddr2];
	end	
	

endmodule // module regs