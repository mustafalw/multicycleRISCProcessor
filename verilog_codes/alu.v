module alu(
	In_ALU_opcode,
	In_ALU_funct,
	In_ALU_srcA_data,
	In_ALU_srcB_data,
	Out_ALU_CFlag,
	Out_ALU_ZFlag,
	Out_ALU_Write_en,
	Out_ALU_result,
	Out_ALU_async,
	In_Zflag_modifier,
	In_Cflag_modifier,
	In_add_enable,
	In_clock,
	In_reset

);
	input [3:0] In_ALU_opcode;
	input [1:0] In_ALU_funct;
	input [15:0] In_ALU_srcA_data;
	input [15:0] In_ALU_srcB_data;
	output reg Out_ALU_CFlag;
	output reg Out_ALU_ZFlag;
	output reg Out_ALU_Write_en;
	output reg [15:0] Out_ALU_result;
	output [15:0] Out_ALU_async;

	input In_Zflag_modifier;
	input In_Cflag_modifier;
	input In_add_enable;
	input In_clock;
	input In_reset;

	wire carry_temp, zero_temp, zero_add, carry_add;
	wire [1:0] op_select;
	wire [15:0] out_add, out_nand, out_xor, out_from_mux;
	
	
	adder_16 add(In_ALU_srcA_data, In_ALU_srcB_data, out_add, carry_add);
	nand_16 nand_gate(In_ALU_srcA_data, In_ALU_srcB_data, out_nand);
	xor_16 xor_gate(In_ALU_srcA_data, In_ALU_srcB_data, out_xor);
	nor_16 nor_add(out_add, zero_add);
	 

   
	mux4x1 output_mux(out_add, out_add, out_nand, out_xor, op_select, out_from_mux);
	
	assign op_select[1] = (In_ALU_opcode[3]|In_ALU_opcode[1])&(~In_add_enable);

	assign op_select[0] = (In_ALU_opcode[2]|In_ALU_opcode[0])&(~In_add_enable);

	assign zero_temp = (In_Zflag_modifier && (In_ALU_funct == 2'b00 || (In_ALU_funct == 2'b10 && Out_ALU_CFlag) || (In_ALU_funct == 2'b01 && Out_ALU_ZFlag))) ?
				(zero_add&(~op_select[1])) :
				Out_ALU_ZFlag;
						
	assign carry_temp = (In_Cflag_modifier && (In_ALU_funct == 2'b00 || (In_ALU_funct == 2'b10 && Out_ALU_CFlag) || (In_ALU_funct == 2'b01 && Out_ALU_ZFlag))) ?
				carry_add :
				Out_ALU_CFlag;

	assign Out_ALU_async = ((&(op_select)) || In_add_enable || In_ALU_funct == 2'b00 || (In_ALU_funct == 2'b10 && Out_ALU_CFlag) || (In_ALU_funct == 2'b01 && Out_ALU_ZFlag)) ?
				out_from_mux :
				Out_ALU_result;	

//	assign Out_ALU_Write_en = (In_ALU_opcode==4'b00x0) && In_ALU_funct == 2'b00 || (In_ALU_funct == 2'b10 && Out_ALU_CFlag) || (In_ALU_funct == 2'b01 && Out_ALU_ZFlag));
				
	always @ (posedge In_clock) begin
	Out_ALU_CFlag <= In_reset ? 1'b0 : carry_temp;
	Out_ALU_ZFlag <= In_reset ? 1'b0 : zero_temp;
	Out_ALU_result <= Out_ALU_async;
	end
			
endmodule
