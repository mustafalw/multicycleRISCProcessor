module nor_16(in1,out);

   output out;
   input [15:0] in1;

   assign out = ~(|(in1));

endmodule