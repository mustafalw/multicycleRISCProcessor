module register16(clk, out, in, write, reset);  // Posedge-triggered flipflop register with active-high write signal an2d reset

	output reg [15:0] out;
	input      [15:0] in;
	input      clk, write, reset;
	
	always@(posedge clk) begin
		if(reset==1) begin
			out = 16'b0;
		end
		else if(write == 1'b1) begin
			out = in;
		end
		else begin
			out = out;
		end
	end
	
endmodule
