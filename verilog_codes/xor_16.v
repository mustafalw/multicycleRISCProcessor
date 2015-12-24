module xor_16(in1, in2, out);

   output [15:0] out;
   input [15:0] in1, in2;

   assign out = in1^in2;

endmodule
