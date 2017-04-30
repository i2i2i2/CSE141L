// one bit full adder

input a, b, ci;
output co, sum;

assign {co, sum} = a + b + ci;


// 8 bit adder

input [7:0] a, b;
input       ci;
output      co;
output [7:0] sum;

assign {co, sum} = a + b + ci;

