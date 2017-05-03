module carry_reg(
  input   clk,
          en,
          reset,
		  set,
          d_in,
  output logic d_out);

always_ff @(posedge clk)
  if(reset==1'b1)
    d_out <= 1'b0;
  else if (set)
    d_out <= 1;
  else if(en)
    d_out <= d_in;

endmodule 