module mux16_8to1(data0,data1,data2,data3,data4,data5,data6,data7,selectinput,out);
input [15:0] data0,data1,data2,data3,data4,data5,data6,data7;
input [2:0] selectinput;
output reg [15:0] out;



always @(*)
begin

case (selectinput)
0:
	out = data0;
1:
	out = data1;
2:
        out = data2;
3:	
	out = data3;
4:
  out = data4;
5:
  out = data5;
6:
  out = data6;
7:
  out = data7;
	
default:
	out = data0;
endcase

end
	
endmodule