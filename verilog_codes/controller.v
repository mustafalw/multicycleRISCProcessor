module controller(IR,
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

input beq_flag;
input flag_multiple;
input [0:15] IR;
input clk;
input reset;
input zero_flag;
input carry_flag;
reg [4:0] StateID,nextStateID;
output reg [2:0] cont_Sig_mux_write_ADDR1,cont_Sig_mux_ALUsrcA,cont_Sig_mux_ALUsrcB;
output reg cont_Sig_mux_mem_addr, cont_Sig_multiple_enable;
output reg [1:0] cont_Sig_mux_write_data1, cont_Sig_mux_read_ADDR1;
output reg RF_en;
output reg setCarry,setZero,add_enable,mem_en,read_wbar,IRwrite;
output reg pcwrite;

always@(StateID)
 begin
      
	  begin
		case(StateID)
		
		   0:begin
			end
			
			1: begin
				cont_Sig_mux_read_ADDR1 = 2'b01; 
				cont_Sig_mux_write_ADDR1 = 3'b011; 
				cont_Sig_mux_write_data1 = 2'b01; 
				RF_en = 1;
				cont_Sig_mux_ALUsrcA = 3'b010;
				cont_Sig_mux_ALUsrcB = 3'b011; 
				add_enable = 1;
				setZero = 0; 
				setCarry = 0; 
				cont_Sig_mux_mem_addr = 1'b0; 
				mem_en = 1; read_wbar = 1'b1; 
				IRwrite = 1;
			   pcwrite=1;
				end

			2: begin
				cont_Sig_mux_read_ADDR1 = 2'b00; 
				cont_Sig_mux_write_ADDR1 = 3'bxxx; 
				cont_Sig_mux_write_data1 = 2'bxx; 
				RF_en = 0; 
				cont_Sig_mux_ALUsrcA = 3'bxxx; 
				cont_Sig_mux_ALUsrcB = 3'bxxx; 
				add_enable = 1'b0; 
				setZero = 1'b0; 
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'bx; 
				mem_en = 0; 
				read_wbar = 1'bx; 
				IRwrite = 0; 
				pcwrite=0;
				cont_Sig_multiple_enable = 1'b0;
			 end
			
			3: begin                                //Add and NAND
			 	cont_Sig_mux_read_ADDR1 = 2'bxx; 
			 	cont_Sig_mux_write_ADDR1 = 3'b010; 
			 	cont_Sig_mux_write_data1 = 2'b01; 
			 	RF_en = 1; 
			 	cont_Sig_mux_ALUsrcA = 3'b000; 
			 	cont_Sig_mux_ALUsrcB = 3'b000; 
			 	add_enable = 1'b0; 
			 	setZero = 1'b1; 
			 	setCarry = 1'b1; 
			 	cont_Sig_mux_mem_addr = 1'bx; 
			 	mem_en = 0; 
			 	read_wbar = 1'bx; 
			 	IRwrite = 0; 	
				pcwrite=0;
			   end			    


	
			4: begin	//Add immediate
			   cont_Sig_mux_read_ADDR1 = 1'bx; 
			 	cont_Sig_mux_write_ADDR1 = 2'b01; 
			 	cont_Sig_mux_write_data1 = 2'b01; 
			 	RF_en = 1; 
			 	cont_Sig_mux_ALUsrcA = 2'b00; 
			 	cont_Sig_mux_ALUsrcB = 2'b10; 
			 	add_enable = 1'b0; 
			 	setZero = 1'b1; 
			 	setCarry = 1'b1; 
			 	cont_Sig_mux_mem_addr = 1'bx; 
			 	mem_en = 0; 
			 	read_wbar = 1'bx; 
			 	IRwrite = 0; 	
				pcwrite=0;
			end
			
			5: 
			   begin   //Load Immediate
			 	cont_Sig_mux_read_ADDR1 = 1'bx; 
			 	cont_Sig_mux_write_ADDR1 = 2'b00; 
			 	cont_Sig_mux_write_data1 = 2'b00; 
			 	RF_en = 1; 
			 	cont_Sig_mux_ALUsrcA = 2'bxx; 
			 	cont_Sig_mux_ALUsrcB = 2'bxx; 
			 	add_enable = 1'b0; 
			 	setZero = 1'b0; 
			 	setCarry = 1'b0; 
			 	cont_Sig_mux_mem_addr = 1'bx; 
			 	mem_en = 0; 
			 	read_wbar = 1'bx; 
			 	IRwrite = 0; 	
				pcwrite=0;
			   end

			6:  begin   //load word	
			     
				 cont_Sig_mux_read_ADDR1 = 1'bx;
				 cont_Sig_mux_write_ADDR1 = 2'bxx;
				 cont_Sig_mux_write_data1 = 2'bxx; 
				 RF_en = 1'b0; 
				 cont_Sig_mux_ALUsrcA = 2'b01;
				 cont_Sig_mux_ALUsrcB = 2'b00;
				 add_enable = 1'b1;
				 setZero = 1'b0; 
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx; 
				 mem_en = 1'b0;
				 read_wbar = 1'bx;
				 IRwrite = 1'b0; 
				 pcwrite=0;
				 
			    end
				 
			13: begin	//Load Word SubState
				cont_Sig_mux_read_ADDR1 = 1'bx; 
				cont_Sig_mux_write_ADDR1 = 2'b00; 
				cont_Sig_mux_write_data1 = 2'b11;
				RF_en = 1'b1; 
				cont_Sig_mux_ALUsrcA = 2'bxx; 
				cont_Sig_mux_ALUsrcB = 2'bxx; 
				add_enable = 1'b0; 
				setZero = 1'b0;
				setCarry = 1'b0;
				cont_Sig_mux_mem_addr = 1'b1; 
				mem_en = 1'b1; 
				read_wbar = 1'b1;
				IRwrite = 1'b0; 
				pcwrite=0;
			
			   end	 
				
			7: begin	//Store word
				cont_Sig_mux_read_ADDR1 = 1'bx; 
				cont_Sig_mux_write_ADDR1 = 2'bxx; 
				cont_Sig_mux_write_data1 = 2'bxx; 
				RF_en = 1'b0; 
				cont_Sig_mux_ALUsrcA = 2'b01; 
				cont_Sig_mux_ALUsrcB = 2'b00; 
				add_enable = 1'b1; 
				setZero = 1'b0; 
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'bx; 
				mem_en = 1'b0; 
				read_wbar = 1'bx; 
				IRwrite = 1'b0; 
				pcwrite=0;
			
			end

			8: begin	//load multiple
				cont_Sig_mux_read_ADDR1 = 2'b00; // read ra at RF_read1
				cont_Sig_mux_write_ADDR1 = 3'b100; // select priority encoder output at write address of RF
				cont_Sig_mux_write_data1 = 2'b11; // select data output from memory at RF data input
				RF_en = |(IR[8:15]); // write in RF only if there was at least one non-zero bit in the 8 bit imm
				cont_Sig_mux_ALUsrcA = 3'b000; // select the output of regA at ALU_srcA 
				cont_Sig_mux_ALUsrcB = 3'b011; // select +1 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'b0; // select RF_read1 as address for memory
				mem_en = 1'b1;
				read_wbar = 1'b1; 
				IRwrite = 1'b0;
				pcwrite=0;
				cont_Sig_multiple_enable = 1'b1;
			end

			9: begin	//store multiple
				cont_Sig_mux_read_ADDR1 = 2'bxx;
				cont_Sig_mux_write_ADDR1 = 3'bxxx;
				cont_Sig_mux_write_data1 = 2'bxx;
				RF_en = 0; // write in RF only if there was at least one non-zero bit in the 8 bit imm
				cont_Sig_mux_ALUsrcA = 3'b000; // select the output of regA at ALU_srcA 
				cont_Sig_mux_ALUsrcB = 3'b100; // select 0 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'bx; // select RF_read1 as address for memory
				mem_en = 1'b0;
				read_wbar = 1'bx; 
				IRwrite = 1'b0;
				pcwrite=0;
				cont_Sig_multiple_enable = 1'b0;
			end
			
			14:  begin	//Store Word Sub State	
				 cont_Sig_mux_read_ADDR1 = 2'b00; 
				 cont_Sig_mux_write_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_data1 = 2'bxx; 
				 RF_en = 1'b0; cont_Sig_mux_ALUsrcA = 2'bxx; 
				 cont_Sig_mux_ALUsrcB = 2'bxx; 
				 add_enable = 1'b0; 
				 setZero = 1'b0; 
				 setCarry = 1'b0; 
				 cont_Sig_mux_mem_addr = 1'b1; 
				 mem_en = 1'b1; 
				 read_wbar = 1'b0; 
				 IRwrite = 1'b0; 
				 pcwrite=0;
			

			end		



			
							
				10: 
	          
				 begin		
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'bxxx; 
				 cont_Sig_mux_write_data1 = 2'bxx; 
				 RF_en = 1'b0; 
				 cont_Sig_mux_ALUsrcA = 3'b000; 
				 cont_Sig_mux_ALUsrcB = 3'b000; 
				 add_enable = 1'b0; 
				 setZero = 1'b0; 
				 setCarry = 1'b0; 
				 cont_Sig_mux_mem_addr = 1'bx; 
				 mem_en = 1'b0; 
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0; 
				 pcwrite=0;
				 
			    end

          
			   15:
			 
			    begin		
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b011; 
				 cont_Sig_mux_write_data1 = 2'b01; 
				 RF_en = 1'b1;
				 cont_Sig_mux_ALUsrcA = 3'b110; 
				 cont_Sig_mux_ALUsrcB = 3'b010; 
				 add_enable = 1'b1; 
				 setZero = 1'b0; 
				 setCarry = 1'b0; 
				 cont_Sig_mux_mem_addr = 1'bx; 
				 mem_en = 1'b0; 
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0; 
				 pcwrite=0;
				 
			    end


	      		11:	//JAL
				 begin		
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b000;	// write PC+1 in ra
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b110; // enable RF and select PC at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b011; 	// select +1 at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=0;
				 end

			12:	//JLR substrate
				begin
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b000;	// write PC+1 in ra
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b110; // enable RF and select PC at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b011; 	// select +1 at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=0;
				end
				

			16:	//JAL substate
				begin		
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b011;	// write PC+Imm in R7
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b110; // enable RF and select PC at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b001; 	// select extend9 at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=0;
				 end

			17:	//JLR substate
				begin		
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b011;	// write rb in R7
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b100; // enable RF and select +0 at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b000; 	// select regB at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=0;
				 end

			18: begin	//load multiple substate
				cont_Sig_mux_read_ADDR1 = 2'bxx;
				cont_Sig_mux_write_ADDR1 = 3'b100; // select priority encoder output at write address of RF
				cont_Sig_mux_write_data1 = 2'b11; // select data output from memory at RF data input
				RF_en = |(IR[8:15]); // write in RF only if there was at least one non-zero bit in the 8 bit imm
				cont_Sig_mux_ALUsrcA = 3'b101; // select ALU_result at ALU_srcA
				cont_Sig_mux_ALUsrcB = 3'b011; // select +1 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'b1; // select ALU_result as address for memory
				mem_en = 1'b1;
				read_wbar = 1'b1; 
				IRwrite = 1'b0;
				pcwrite=0;
				cont_Sig_multiple_enable = 1'b1;
			end

			19: begin	//store multiple substate
				cont_Sig_mux_read_ADDR1 = 2'b10;
				cont_Sig_mux_write_ADDR1 = 3'bxxx;
				cont_Sig_mux_write_data1 = 2'bxx;
				RF_en = |(IR[8:15]);
				cont_Sig_mux_ALUsrcA = 3'b101; // select ALU_result at ALU_srcA
				cont_Sig_mux_ALUsrcB = 3'b011; // select +1 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0;
				cont_Sig_mux_mem_addr = 1'b1; // select ALU_result as address for memory
				mem_en = |(IR[8:15]);
				read_wbar = 1'b0;
				IRwrite = 1'b0;
				pcwrite=0;
				cont_Sig_multiple_enable = 1'b1;
			end
			
			endcase
				
			
		end

end

always@(IR or carry_flag or zero_flag or reset or StateID or flag_multiple or beq_flag)
 begin
     if(reset) nextStateID = 0;
	  else
	  begin
		case(StateID)
		
		   0: nextStateID = 1;
			
			1: begin 
				nextStateID = 2;
			end

			2: begin
			case(IR[0:3])
			4'b0000:                         //ADD
					      begin
							  
							  if(IR[14:15]==2'b00)
							  
							  begin
							  nextStateID = 3;
							  end
						    
							  else if(IR[14:15]==2'b10 && carry_flag==1)
							 
							  begin
							  nextStateID = 3;
							  end
							  
							  else if(IR[14:15]==2'b10 && carry_flag==0)
							 
							  begin
							  nextStateID = 1;
							  end
							  
							  else if (IR[14:15]==2'b01 && zero_flag==1)
					        begin
							  nextStateID = 3;
							  end
							  
							  else if(IR[14:15]==2'b01 && zero_flag==0)
							  begin
							  nextStateID = 1;
							  end
						 end
							  
					4'b0001:								//Add immediate	
				        	 begin
						 nextStateID =4; 
						 end
						
						
					4'b0010:								//NAND instruction 
						
							begin
							
							  if(IR[14:15]==00)
							  
							  begin
							  nextStateID = 3;
							  end
						    
							  else if(IR[14:15]==2'b10 && carry_flag==1)
							 
							  begin
							  nextStateID = 3;
							  end
							  
							  else if(IR[14:15]==2'b10 && carry_flag==0)
							 
							  begin
							  nextStateID = 1;
							  end
							  
							  else if (IR[14:15]==2'b01 && zero_flag==1)
					        	  begin
							  nextStateID = 3;
							  end
							  
							  else if(IR[14:15]==2'b01 && zero_flag==0)
							  begin
							  nextStateID = 1;
							  end
							  
						  end
							
							
				
					4'b0011: nextStateID = 5;				//Load Immediate
					
					4'b0100: nextStateID = 6;				//Load Word
					
					4'b0101: nextStateID = 7;				//Store Word			
					  
					4'b0110: nextStateID = 8;				//LM

					4'b0111: nextStateID = 9;				//SM
					
					4'b1100: nextStateID = 10;			   	//BEQ
					
					4'b1000: nextStateID = 11;				//JAL
					
					4'b1001: nextStateID = 12;				//JLR
					
				endcase
			end	

			3: begin                                //Add and NAND
			 	nextStateID = 1;
			   end			    


	
			4: begin	//Add immediate
			   nextStateID = 1;
			end
			
			5: 
			   begin   //Load Immediate
			 	nextStateID = 1;
			   end

			6:  begin   //load word	
			      nextStateID = 13;
			    end
				 
			13: begin   //Load Word SubState
				nextStateID = 1;

			   end	 
				
			7: begin    //Store word
				nextStateID = 14;
			end

			8: begin
			if(~flag_multiple) nextStateID = 18;
			else nextStateID = 1;
			end

			9: begin
			nextStateID = 19;
			end
			
			14:  begin  //Store Word Sub State	
				 nextStateID = 1;

			end
			
			10: begin
			
			    if(beq_flag)
				 
				nextStateID = 15;     //beq nextState
				 
				 else
		      
	          		nextStateID =	1;
			end
			
			11: 
			   begin 
				nextStateID = 16;
			   end
	 
			12:
			   begin
				nextStateID = 17;
			end

		      	15: begin
				    nextStateID = 1;
			  end
		 
		      	16: begin //JAL substate
				nextStateID=1;
			end
			
				
			17: begin //JLR substate
	  			nextStateID = 1;
			end

			18: begin
			if(flag_multiple) 
			begin nextStateID = 1; 
			end			
			else 
			begin nextStateID = 18;
		   end
			end

			19: begin
			if(flag_multiple) 
			begin nextStateID = 1; 
			end			
			else 
			begin nextStateID = 19;
		   end
			end

			
			default: begin
				
			nextStateID = 0;

			end
		
		endcase
		end

end

	always@(posedge clk) 
	begin
//	
//		if(reset)
//		  begin
//		  StateID<=0;
//		  end
//		else
		StateID <= nextStateID;
		
	end

endmodule
