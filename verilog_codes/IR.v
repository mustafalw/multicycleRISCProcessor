module in_reg(latch_enable,in,out);

input latch_enable;
input [15:0] in;
output reg [15:0] out;

always@(*)
begin
if(latch_enable)
  out=in ;
else
  out=out;
  
end

endmodule
