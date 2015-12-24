
module mux8_2to1(data0,data1,selectinput,out);
input [7:0] data0,data1;
input selectinput;
output reg [7:0] out;

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
