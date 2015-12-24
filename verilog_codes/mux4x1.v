module mux4x1(in1, in2, in3, in4, selectInput, out);

	output reg [15:0] out;
	input [15:0] in1, in2, in3, in4;
	input [1:0] selectInput;
	
	always@(in1 or in2 or in3 or in4 or selectInput) begin
		case(selectInput)
			0: out = in1;
			1: out = in2;
			2: out = in3;
			3: out = in4;
		endcase
	end
	
	
endmodule