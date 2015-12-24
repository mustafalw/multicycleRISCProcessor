//Comments about naming
//clk,reset -> uniform all over the code
//cont_Sig_mux_read_ADDR1 -> control signal for mux
//reg_A,reg_B
//RF_en -> for enabling RF
module dataPath(
clk,
reset,
cont_Sig_mux_ALUsrcA,
cont_Sig_mux_ALUsrcB,
cont_Sig_mux_mem_addr,
cont_Sig_mux_read_ADDR1,
cont_Sig_mux_write_ADDR1,
cont_Sig_mux_write_data1,
cont_Sig_multiple_enable,
RF_en,
setCarry,
setZero,
add_enable,
mem_en,
read_wbar,
IRwrite,
IR1,
zero_out,
carry_out,
flag_multiple,
pcwrite,
beq_flag
);

input clk,reset;
input [2:0] cont_Sig_mux_write_ADDR1,cont_Sig_mux_ALUsrcA,cont_Sig_mux_ALUsrcB;
input cont_Sig_mux_mem_addr, cont_Sig_multiple_enable;
input [1:0] cont_Sig_mux_write_data1, cont_Sig_mux_read_ADDR1;
input RF_en;
input setCarry,setZero,add_enable,mem_en,read_wbar,IRwrite;
input pcwrite;


output wire [0:15] IR1;
output wire zero_out;
output wire carry_out;
output wire flag_multiple;
output wire beq_flag;

wire [2:0] out_mux_write_ADDR1;
wire [2:0] priorityencoderout;
wire [0:15] IR;
wire [2:0] out_mux_read_ADDR1;
wire [15:0] appended16;
wire [15:0] ALU_async;
wire [15:0] ALU_result;
wire [15:0] mem_read_data;
wire [15:0] out_mux_write_data1;
wire [15:0] in_wire_A;
wire [15:0] in_wire_B;
wire [15:0] out_wire_A;
wire [15:0] out_wire_B;
wire writeA,writeB;
wire [15:0] extend6;
wire [15:0] extend9;
wire [15:0] out_mux_srcA;
wire [15:0] out_mux_srcB;
wire carryFlag,zeroFlag;
wire Out_ALU_Write_en;
wire [15:0]out_mux_mem_addr;
wire [15:0] pc_out;

assign IR1=IR;
assign zero_out=zeroFlag;
assign carry_out=carryFlag;

// input ->
// output ->
//wire -> appended16,in_wire_A,in_wire_B
mux3_4to1 mux_read_ADDR1(
.data0(IR[4:6]),
.data1(3'b111),
.data2(priorityencoderout),
.data3(priorityencoderout),
.selectinput(cont_Sig_mux_read_ADDR1),
.out(out_mux_read_ADDR1)
);

mux3_8to1 mux_write_ADDR1(
.data0(IR[4:6]),
.data1(IR[7:9]),
.data2(IR[10:12]),
.data3(3'b111),
.data4(priorityencoderout),
.data5(priorityencoderout),
.data6(priorityencoderout),
.data7(priorityencoderout),
.selectinput(cont_Sig_mux_write_ADDR1),
.out(out_mux_write_ADDR1)
);

zeroAppend zApp(
.in(IR[7:15]),
.out(appended16)
);

mux16_4x1 mux_write_data1(
.in1(appended16),
.in2(ALU_async),  // async out from ALU i.e. changes as soon as input changes
.in3(ALU_result), // sync out from ALU i.e. changes at posedge of clock
.in4(mem_read_data),
.selectInput(cont_Sig_mux_write_data1),
.out(out_mux_write_data1)
);

register_file RF(
.In_RF_Read_addr1(out_mux_read_ADDR1),
.In_RF_Read_addr2(IR[7:9]),
.Out_RF_Read_data1(in_wire_A),
.Out_RF_Read_data2(in_wire_B),
.In_RF_Write_addr1(out_mux_write_ADDR1),
.In_RF_Write_data1(out_mux_write_data1),
.In_RF_Write_en_1(RF_en),
.In_clock(clk),
.In_reset(reset)
);

assign writeA=1;
register16 regA(
.clk(clk),
.out(out_wire_A),
.in(in_wire_A),
.write(writeA),
.reset(reset)
);

assign writeB=1;
register16 regB(
.clk(clk),
.out(out_wire_B),
.in(in_wire_B),
.write(writeB),
.reset(reset)
); 


signExt6to16 e6(
.in(IR[10:15]), // the six bits are in the MSB not LSB!!!
.out(extend6)
);

signExt9to16 e9(
.in(IR[7:15]), // same here
.out(extend9)
);

mux16_8to1 mux_ALU_srcA(
.data0(out_wire_A),
.data1(extend6),
.data2(in_wire_A),
.data3(mem_read_data),
.data4(16'd0),
.data5(ALU_result),
.data6(pc_out),
.data7(pc_out),
.selectinput(cont_Sig_mux_ALUsrcA),
.out(out_mux_srcA)
);

mux16_8to1 mux_ALU_srcB(
.data0(out_wire_B),
.data1(extend9),
.data2(extend6),
.data3(16'b1),
.data4(16'b0),
.data5(16'b0),
.data6(16'b0),
.data7(16'b0),
.selectinput(cont_Sig_mux_ALUsrcB),
.out(out_mux_srcB)
);


register16 PC(
.clk(clk),
.out(pc_out),
.in(in_wire_A),
.write(pcwrite),
.reset(reset)
);

alu my_alu(
	.In_ALU_opcode(IR[0:3]),
	.In_ALU_funct(IR[14:15]),
	.In_ALU_srcA_data(out_mux_srcA),
	.In_ALU_srcB_data(out_mux_srcB),
	.Out_ALU_CFlag(carryFlag),
	.Out_ALU_ZFlag(zeroFlag),
	.Out_ALU_Write_en(Out_ALU_Write_en),
	.Out_ALU_result(ALU_result),
	.Out_ALU_async(ALU_async),
	.In_Zflag_modifier(setZero),
	.In_Cflag_modifier(setCarry),
	.In_add_enable(add_enable),
	.In_clock(clk),
	.In_reset(reset)
);

nor_16 flag_beq(ALU_async,beq_flag);

memory my_mem(
.In_Mem_Access_en(mem_en),
.In_Mem_Access_R_Wbar(read_wbar),
.In_Mem_Access_addr(out_mux_mem_addr),	// the address input comes either from ALU_result or out_wire_A
.In_Mem_Write_data(in_wire_A),	// the write data is input of the register A i.e. regA
.Out_Mem_Read_data(mem_read_data),
.In_clock(clk),
.In_reset(reset)
);

mux16_2to1 mux_mem_addr(
.data0(in_wire_A),
.data1(ALU_result),
.selectinput(cont_Sig_mux_mem_addr),
.out(out_mux_mem_addr)
);

register16 instr_reg(
.clk(clk),
.out(IR),
.in(mem_read_data),
.write(IRwrite),
.reset(reset));

multiple_handler m1(.clk(clk), .reset(reset), .pren_out(priorityencoderout), .selectinput(cont_Sig_multiple_enable), .inputfromIR(IR[8:15]), .flag_multiple(flag_multiple));

endmodule

module test_datapath;

reg [1:0] cont_Sig_mux_ALUsrcA, cont_Sig_mux_ALUsrcB, cont_Sig_mux_write_ADDR1, cont_Sig_mux_write_data1;
reg cont_Sig_mux_mem_addr, cont_Sig_mux_read_ADDR1, RF_en, reset, setCarry, setZero, add_enable, mem_en, read_wbar, IRwrite;

reg clock = 1;
always #5 clock = ~clock;

initial begin
#0 reset = 1;

//lhi instruction
#11 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1'b1; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'b0; mem_en = 1'b1; read_wbar = 1'b1; IRwrite = 1'b1; 
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b00; cont_Sig_mux_write_data1 = 2'b00; RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 

//#11 reset = 0; cont_Sig_mux_read_ADDR1 = 1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1; setZero = 0; setCarry = 0; cont_Sig_mux_mem_addr = 0; mem_en = 1; read_wbar = 1; IRwrite = 1;
//#10 reset =0; cont_Sig_mux_read_ADDR1 = 0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 
//#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b00; cont_Sig_mux_write_data1 = 2'b00; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 

//load second
#10 reset = 0; cont_Sig_mux_read_ADDR1 = 1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1; setZero = 0; setCarry = 0; cont_Sig_mux_mem_addr = 0; mem_en = 1; read_wbar = 1; IRwrite = 1; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b00; cont_Sig_mux_write_data1 = 2'b00; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 

//add r0,r1,r2

#10 reset = 0; cont_Sig_mux_read_ADDR1 = 1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1; setZero = 0; setCarry = 0; cont_Sig_mux_mem_addr = 0; mem_en = 1; read_wbar = 1; IRwrite = 1; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b10; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b00; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b0; setZero = 1'b1; setCarry = 1'b1; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 

// add r0,r1,r2 , Add content of regB to regA and store result in regC, if carry flag is set

#10 reset = 0; cont_Sig_mux_read_ADDR1 = 1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1; setZero = 0; setCarry = 0; cont_Sig_mux_mem_addr = 0; mem_en = 1; read_wbar = 1; IRwrite = 1; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b10; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b00; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b0; setZero = 1'b1; setCarry = 1'b1; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 


//sw instruction
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1'b1; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'b0; mem_en = 1'b1; read_wbar = 1'b1; IRwrite = 1'b1; 

#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 
//S2
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'b01; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b1; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 
//S3
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'b1; mem_en = 1'b1; read_wbar = 1'b0; IRwrite = 1'b0; 

//lw instruction , lw ra, rb,Imm
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1'b1; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'b0; mem_en = 1'b1; read_wbar = 1'b1; IRwrite = 1'b1; 

#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 
//S2
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'b01; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b1; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 
//S3
#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b00; cont_Sig_mux_write_data1 = 2'b11; RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'b1; mem_en = 1'b1; read_wbar = 1'b1; IRwrite = 1'b0; 

//NDU rc, ra,rb -> NAND the content of regB to regA and store result in regC

#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1'b1; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'b0; mem_en = 1'b1; read_wbar = 1'b1; IRwrite = 1'b1; 

#10 reset = 1'b0; cont_Sig_mux_read_ADDR1 = 1'b0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 1'b0; read_wbar = 1'bx; IRwrite = 1'b0; 

#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b10; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b00; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 


//NDC rc, ra,rb -> NAND the content of regB to regA and store result in regC if carry flag is set

#10 reset = 0; cont_Sig_mux_read_ADDR1 = 1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1; setZero = 0; setCarry = 0; cont_Sig_mux_mem_addr = 0; mem_en = 1; read_wbar = 1; IRwrite = 1; 

#10 reset =0; cont_Sig_mux_read_ADDR1 = 0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 

#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b10; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b00; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b0; setZero = 1'b1; setCarry = 1'b1; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 

//NDZ rc, ra,rb -> NAND the content of regB to regA and store result in regC if zero flag is set

#10 reset = 0; cont_Sig_mux_read_ADDR1 = 1; cont_Sig_mux_write_ADDR1 = 2'b11; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b10; cont_Sig_mux_ALUsrcB = 2'b11; add_enable = 1; setZero = 0; setCarry = 0; cont_Sig_mux_mem_addr = 0; mem_en = 1; read_wbar = 1; IRwrite = 1;
 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 0; cont_Sig_mux_write_ADDR1 = 2'bxx; cont_Sig_mux_write_data1 = 2'bxx; RF_en = 0; cont_Sig_mux_ALUsrcA = 2'bxx; cont_Sig_mux_ALUsrcB = 2'bxx; add_enable = 1'b0; setZero = 1'b0; setCarry = 1'b0; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 
#10 reset =0; cont_Sig_mux_read_ADDR1 = 1'bx; cont_Sig_mux_write_ADDR1 = 2'b10; cont_Sig_mux_write_data1 = 2'b01; RF_en = 1; cont_Sig_mux_ALUsrcA = 2'b00; cont_Sig_mux_ALUsrcB = 2'b00; add_enable = 1'b0; setZero = 1'b1; setCarry = 1'b1; cont_Sig_mux_mem_addr = 1'bx; mem_en = 0; read_wbar = 1'bx; IRwrite = 0; 

end

dataPath d1(
clock,
reset,
cont_Sig_mux_ALUsrcA,
cont_Sig_mux_ALUsrcB,
cont_Sig_mux_mem_addr,
cont_Sig_mux_read_ADDR1,
cont_Sig_mux_write_ADDR1,
cont_Sig_mux_write_data1,
RF_en,
setCarry,
setZero,
add_enable,
mem_en,
read_wbar,
IRwrite
);

endmodule
