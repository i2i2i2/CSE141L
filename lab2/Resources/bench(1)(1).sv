`timescale 1ns/1ps
module bench;

parameter dw = 8;
// bit self-inits to 0, has no x, z
bit               clk;
bit  signed [dw-1:0] a;
bit  signed [dw-1:0] b;
wire signed [dw-1:0] c;

// CSE141L  Winter 2014
// different seeds -> different 
//  pseudorandom sequences
int seed_a = 29;
int seed_b = 73;

adder_demo #(.dw(dw)) ad
  (.clk,   // same as .clk(clk),
   .a,
   .b,
   .cq(c));

// why not for(logic[3:0] i = ...)?
initial begin
  for(int i = 0; i<16; i++) begin
    a = $random(seed_a);
	b = $random(seed_b);
    #5ns clk = 1;	 // or = 1'b1;
    #5ns $display(a,,b,,c);
	clk = 0;
  end
end

integer c0;

always @(posedge clk) begin
// don't try to synthesize this -- 
//   why??
  c0 <= #10ns a + b;
  assert (c0 == c)
    else $warning("error  ",$time);
end

endmodule