module multiple_handler(
clk,
reset,
pren_out,
selectinput,
inputfromIR,
flag_multiple);

	input clk, reset, selectinput;
	input [0:7] inputfromIR;
	output [2:0] pren_out;
	output flag_multiple;

	wire [7:0] mux_out, reg_out, out_and8, decoder_out;

	register8 code_reg(.clk(clk), .reset(reset), .write(1'b1), .in(mux_out), .out(reg_out));

	mux8_2to1 mux_code_select(.data0(inputfromIR), .data1(out_and8), .selectinput(selectinput), .out(mux_out));

	priorityEncoder_8x3 p1(.in(reg_out), .out(pren_out));

	decoder_3x8 d1(.in(pren_out), .out(decoder_out));

	and8bit and_IR_decoder(.in1(decoder_out), .in2(reg_out),.out(out_and8));
	
	assign flag_multiple = ~(|(out_and8));
   
	
endmodule

module test_multiple_handler;

	reg clk, reset, cont_Sig_code_select;
	reg [0:15] IR;
	wire [2:0] pren_out;

	multiple_handler m1(.clk(clk), .reset(reset), .inputfromIR(IR[8:15]), .pren_out(pren_out), .selectinput(cont_Sig_code_select));

	always #5 clk = ~clk;

	initial begin
	#0 clk = 0; reset = 1;
	#10 reset = 0;
	#5 IR = 16'b0000000010101010; cont_Sig_code_select = 0;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	#10 cont_Sig_code_select = 1;
	end

	

endmodule

