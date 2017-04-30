// CSE141L   Winter 2014
// our DUT
module adder_demo
  #(parameter dw = 16) (
  input                       clk,
  input        signed[dw-1:0] a, b,
  output logic signed[dw-1:0] cq	   );

logic signed[dw-1:0] aq, bq, c;

// two-loop style (sequential & combo)
// update I/O registers
always @(posedge clk) begin
  aq <= a;
  bq <= b;
  cq <= c;
end

// the adder itself
assign c = aq + bq;

endmodule