module register8(clk, out, in, write, reset);  // Posedge-triggered flipflop register with active-high write signal an2d reset

	output reg [7:0] out;
	input      [7:0] in;
	input      clk, write, reset;
	
	always@(posedge clk) begin
		if(reset==1) begin
			out = 8'b0;
		end
		else if(write == 1'b1) begin
			out = in;
		end
		else begin
			out = out;
		end
	end
	
endmodule
