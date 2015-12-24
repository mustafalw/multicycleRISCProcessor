module register_file(
In_RF_Read_addr1,
In_RF_Read_addr2,
Out_RF_Read_data1,
Out_RF_Read_data2,
In_RF_Write_addr1,
In_RF_Write_data1,
In_RF_Write_en_1,
In_clock,
In_reset
);
input [2:0] In_RF_Read_addr1,In_RF_Read_addr2,In_RF_Write_addr1;
input In_clock,In_reset, In_RF_Write_en_1;
input [15:0] In_RF_Write_data1;
output [15:0] Out_RF_Read_data1, Out_RF_Read_data2;

wire   [15:0] data0,  data1,  data2,  data3,  data4,  data5,  data6,  data7;
wire   [7:0]  writeLinesInit, writeLines;
	
demux8 dem(In_RF_Write_addr1, writeLinesInit);
mux16x8 mux1(data0, data1, data2, data3, data4, data5, data6, data7, In_RF_Read_addr1, Out_RF_Read_data1);
mux16x8 mux2(data0, data1, data2, data3, data4, data5, data6, data7, In_RF_Read_addr2, Out_RF_Read_data2);

and a0(writeLines[0], In_RF_Write_en_1, writeLinesInit[0]);
and a1(writeLines[1], In_RF_Write_en_1, writeLinesInit[1]);
and a2(writeLines[2], In_RF_Write_en_1, writeLinesInit[2]);
and a3(writeLines[3], In_RF_Write_en_1, writeLinesInit[3]);
and a4(writeLines[4], In_RF_Write_en_1, writeLinesInit[4]);
and a5(writeLines[5], In_RF_Write_en_1, writeLinesInit[5]);
and a6(writeLines[6], In_RF_Write_en_1, writeLinesInit[6]);
and a7(writeLines[7], In_RF_Write_en_1, writeLinesInit[7]);

register16 r0(In_clock, data0, In_RF_Write_data1, writeLines[0], In_reset);
register16 r1(In_clock, data1, In_RF_Write_data1, writeLines[1], In_reset);
register16 r2(In_clock, data2, In_RF_Write_data1, writeLines[2], In_reset);
register16 r3(In_clock, data3, In_RF_Write_data1, writeLines[3], In_reset);
register16 r4(In_clock, data4, In_RF_Write_data1, writeLines[4], In_reset);
register16 r5(In_clock, data5, In_RF_Write_data1, writeLines[5], In_reset);
register16 r6(In_clock, data6, In_RF_Write_data1, writeLines[6], In_reset);
register16 r7(In_clock, data7, In_RF_Write_data1, writeLines[7], In_reset);
	
endmodule
