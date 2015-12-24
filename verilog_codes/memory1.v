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
reg [15:0] mem[63:0];

// If reset is 1(i.e. ON) then Out_Mem_Read_data will show 0 as output; 

initial begin
//mem[0] = 16'b1100110101000010;
//mem[0] = 16'b1000000000000010; // jal r0, 000000010 i.e. store PC+1 in r0 and jump to PC+2
//mem[0] = 16'b0011000111010101; // load immediate 111010101 in R0
//mem[1] = 16'b0011001111010101; // load immediate 111010101 in R1
//mem[2] = 16'b0000000001010000; // add r0,r1,r2
//mem[3] = 16'b0001000111011010; // addc r0,r7,r2 if carry
//mem[2] = 16'b0101000110001011; // store r0 in rb+11
//mem[3] = 16'b0101001110001100; // store r1 in rb+12
//mem[2] = 16'b0101100101000000; // store r4 into memory at r5+0
//mem[3] = 16'b0100110101000000; // load r5+0 from memory into r6
//mem[3] = 16'b0111100000010011;
//mem[3] = 16'b0000000001010000; // add r0, r1, r2
//mem[3] = 16'b0111011000000000;
//mem[6] = 16'b0010000100110001;
//mem[7] = 16'b0010000101001010;
	mem[0] = 16'b1000000000011101;
	mem[1] = 16'b0100100110000101;
	mem[2] = 16'b0001110000111101;
	mem[3] = 16'b0100110110000101;
	mem[4] = 16'b0110000000000011;
	mem[5] = 16'b0001000010000000;
	mem[6] = 16'b0010000001011000;
	mem[7] = 16'b0010011011011000;
	mem[8] = 16'b0001011011000000;
	mem[9] = 16'b0000100010100001;
	mem[10] = 16'b0000000000000000;
	mem[11] = 16'b0010110110110010;
	mem[12] = 16'b1100110101111010;
	mem[13] = 16'b0101100101010110;
	mem[20] = 16'b0000000000000001;
	mem[21] = 16'b0000000000001111;
	
	//mem[22] = 16'b0000000000001100;
	mem[23] = 16'b1111111111111111;
	mem[24] = 16'b0000000001000101;
	//mem[25] = 16'b1111111110111011;
	//mem[26] = 16'b0000000001000100;	
	
	
	mem[28] = 16'b0000000000000000;

	mem[29] = 16'b0001011011000001;
	mem[30] = 16'b0001110110010111;
	mem[31] = 16'b0101000110000100;
	mem[32] = 16'b0100000110000000;
	mem[33] = 16'b0100001110000001;
	mem[34] = 16'b1100101001001100;
	mem[35] = 16'b0000000010010000;
	mem[36] = 16'b0000011100100010;
	mem[37] = 16'b0001001001111111;
	mem[38] = 16'b0001111111111100;	
	
	mem[46] = 16'b0001110000000010;
	mem[47] = 16'b0111000000010100;
	mem[48] = 16'b0001011011111111;
	mem[49] = 16'b0101011110000101;
	mem[50] = 16'b0100111110000100;
	
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
