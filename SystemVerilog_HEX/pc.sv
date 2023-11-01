
module pc #(parameter Psize = 4) // up to 16 instructions
(input logic clk, reset, PCincr,
 output logic [Psize-1 : 0]PCout
);

//------------- code starts here---------
logic[Psize-1:0] Rbranch; // temp variable for addition operand
always_comb
  if (PCincr)
       Rbranch = { {(Psize-1){1'b0}}, 1'b1};
  else Rbranch =  {Psize{1'b0}};


always_ff @ ( posedge clk or posedge reset) // async reset
  if (reset) // sync reset
     PCout <= {Psize{1'b0}};
  else// increment or relative branch
     PCout <= PCout + Rbranch; // 1 adder does both

	 
endmodule // module pc