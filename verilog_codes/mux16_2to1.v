module mux16_2to1(data0,data1,selectinput,out);
input [15:0] data0,data1;
input selectinput;
output reg [15:0] out;

always @(*)
begin
case (selectinput)
	0:
	out = data0;
	1:
	out = data1;
	default:
	out = data0;
endcase
end
endmodule
