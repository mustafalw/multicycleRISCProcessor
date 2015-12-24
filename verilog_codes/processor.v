module processor(clk,reset);
input clk,reset;
wire carry_flag;
wire zero_flag;
wire [0:15] IR;
wire [2:0] cont_Sig_mux_write_ADDR1,cont_Sig_mux_ALUsrcA,cont_Sig_mux_ALUsrcB;
wire cont_Sig_mux_mem_addr, cont_Sig_multiple_enable;
wire [1:0] cont_Sig_mux_write_data1, cont_Sig_mux_read_ADDR1;
wire RF_en;
wire setCarry,setZero,add_enable,mem_en,read_wbar,IRwrite;
wire flag_multiple;
wire pcwrite;
wire beq_flag;

dataPath d1(.IR1(IR),
.clk(clk),
.reset(reset),
.cont_Sig_mux_ALUsrcA(cont_Sig_mux_ALUsrcA),
.cont_Sig_mux_ALUsrcB(cont_Sig_mux_ALUsrcB),
.cont_Sig_mux_mem_addr(cont_Sig_mux_mem_addr),
.cont_Sig_mux_read_ADDR1(cont_Sig_mux_read_ADDR1),
.cont_Sig_mux_write_ADDR1(cont_Sig_mux_write_ADDR1),
.cont_Sig_mux_write_data1(cont_Sig_mux_write_data1),
.cont_Sig_multiple_enable(cont_Sig_multiple_enable),
.RF_en(RF_en),
.setCarry(setCarry),
.setZero(setZero),
.add_enable(add_enable),
.mem_en(mem_en),
.read_wbar(read_wbar),
.IRwrite(IRwrite),
.zero_out(zero_flag),
.carry_out(carry_flag),
.flag_multiple(flag_multiple),
.pcwrite(pcwrite),
.beq_flag(beq_flag)
);

controller c1(IR,
clk,
reset,
zero_flag,
carry_flag,
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
flag_multiple,
pcwrite,
beq_flag
);

endmodule
