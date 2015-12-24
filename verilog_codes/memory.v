module memory(
In_Mem_Access_en,
In_Mem_Access_R_Wbar,
In_Mem_Access_addr,
In_Mem_Write_data,
Out_Mem_Read_data,
In_clock,
In_reset
);
input In_Mem_Access_en,In_Mem_Access_R_Wbar,In_clock,In_reset;
input [15:0] In_Mem_Access_addr;
input [15:0] In_Mem_Write_data;
output reg [15:0] Out_Mem_Read_data;

// Declare the memory here
// Total 2^16 possible locations
reg [15:0] mem[31:0];

// If reset is 1(i.e. ON) then Out_Mem_Read_data will show 0 as output; 

initial begin
//mem[0] = 16'b1100110101000010;
//mem[0] = 16'b1000000000000010; // jal r0, 000000010 i.e. store PC+1 in r0 and jump to PC+2
  mem[0] = 16'b0011000111010101; // load immediate 111010101 in R0
  mem[1] = 16'b0011001111010101; // load immediate 111010101 in R1
//mem[2] = 16'b0000000001010000; // add r0,r1,r2
//mem[3] = 16'b0001000111011010; // addc r0,r7,r2 if carry
//mem[2] = 16'b0101000110001011; // store r0 in rb+11
//mem[3] = 16'b0101001110001100; // store r1 in rb+12
  mem[2] = 16'b0110100000000111; //
  mem[3] = 16'b0111100000010011;
//mem[3] = 16'b0000000001010000; // add r0, r1, r2
//mem[3] = 16'b0111011000000000;
//mem[6] = 16'b0010000100110001;
//mem[7] = 16'b0010000101001010;
end




//Data is read when In_Mem_Access_R_Wbar is high and In_Mem_Access_en is high.

always @ (*) 
begin
   
	if(In_reset)
	begin
   Out_Mem_Read_data <= 16'b0;
   end

	else if(In_Mem_Access_R_Wbar && In_Mem_Access_en && ~In_reset  )
	begin
		Out_Mem_Read_data <=mem[In_Mem_Access_addr];	
	end
	
	else Out_Mem_Read_data<=Out_Mem_Read_data;
end

//Data is written at positive edge of the clock when In_Mem_Access_R_Wbar is low and In_Mem_Access_en is high

always @(posedge In_clock)
begin
	if(In_Mem_Access_R_Wbar == 0 && In_Mem_Access_en == 1 && ~In_reset)
	begin 
		mem[In_Mem_Access_addr] <= In_Mem_Write_data;
	end
end

endmodule
