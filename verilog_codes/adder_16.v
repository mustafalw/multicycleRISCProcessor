module adder_16(in1, in2, out, carry);
   output [15:0] out;
   output carry;
   input [15:0] in1, in2;

   assign {carry, out} = in1 +in2;

endmodule   
