module priorityEncoder_8x3(
in,
out);

	output reg [2:0] out;

	input [7:0] in;

	always@(*)
	begin

		if(in[0]) out = 3'b000;
		else if(in[1]) out = 3'b001;
		else if(in[2]) out = 3'b010;
		else if(in[3]) out = 3'b011;
		else if(in[4]) out = 3'b100;
		else if(in[5]) out = 3'b101;
		else if(in[6]) out = 3'b110;
		else out = 3'b111;

	end

endmodule
