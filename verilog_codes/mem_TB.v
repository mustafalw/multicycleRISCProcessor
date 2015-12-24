module test ;   
	reg clk,In_Mem_Access_en1,In_Mem_Access_R_Wbar1,In_reset1; 
	reg [15:0] In_Mem_Access_addr1,In_Mem_Write_data1;  
	wire [15:0] Out_Mem_Read_data1; 
Memory  i0(In_Mem_Access_en1,
In_Mem_Access_R_Wbar1,
In_Mem_Access_addr1,
In_Mem_Write_data1,
Out_Mem_Read_data1,
clk,
In_reset1
); 
initial
begin 
	clk = 1; 
	In_reset1 =0;
//write @16'b0
	#20 In_Mem_Access_R_Wbar1 = 0; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'b0 ; In_Mem_Write_data1 = 16'd13 ;
//read @16'b0
	#20 In_Mem_Access_R_Wbar1 = 1; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'b0; 
//write @16'd17	
	#20 In_Mem_Access_R_Wbar1 = 0; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'd17 ; In_Mem_Write_data1 = 16'd23 ;
//read @16'd17
	#20 In_Mem_Access_R_Wbar1 = 1; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'd17;
//write @16'd30		 
	#20 In_Mem_Access_R_Wbar1 = 0; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'd30 ; In_Mem_Write_data1 = 16'd53 ;
//read @16'b0
	#20 In_Mem_Access_R_Wbar1 = 1; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'b0;
//read @16'd17
	#20 In_Mem_Access_R_Wbar1 = 1; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'd17; 
//read @16'd30
	#20 In_Mem_Access_R_Wbar1 = 1; In_Mem_Access_en1 = 1; In_Mem_Access_addr1 = 16'd30; 	
	#10 $stop;
end 
always #10 clk = ~clk;
initial
$monitor("At time %t, value = %0d",$time, Out_Mem_Read_data1);
endmodule
