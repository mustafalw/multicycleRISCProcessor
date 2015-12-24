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
cont_Sig_mux_mem_wdata,
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
output reg cont_Sig_mux_mem_addr, cont_Sig_multiple_enable,cont_Sig_mux_mem_wdata;
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
				RF_en = 1'b1;
				cont_Sig_mux_ALUsrcA = 3'b010;
				cont_Sig_mux_ALUsrcB = 3'b011; 
				add_enable = 1'b1;
				setZero = 1'b0; 
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'b0; 
				cont_Sig_mux_mem_wdata =1'b0;
				mem_en = 1'b1;
				read_wbar = 1'b1; 
				IRwrite = 1'b1;
			   pcwrite=1'b1;
				
				end

			2: begin
				cont_Sig_mux_read_ADDR1 = 2'b00; 
				cont_Sig_mux_write_ADDR1 = 3'bxxx; 
				cont_Sig_mux_write_data1 = 2'bxx; 
				RF_en = 1'b0; 
				cont_Sig_mux_ALUsrcA = 3'bxxx; 
				cont_Sig_mux_ALUsrcB = 3'bxxx; 
				add_enable = 1'b0; 
				setZero = 1'b0; 
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'bx; 
				cont_Sig_mux_mem_wdata =1'b0;
				mem_en = 1'b0; 
				read_wbar = 1'bx; 
				IRwrite = 1'b0; 
				pcwrite=1'b0;
				cont_Sig_multiple_enable = 1'b0;
			   end
			
			3: begin                                //Add and NAND
			 	cont_Sig_mux_read_ADDR1 = 2'bxx; 
			 	cont_Sig_mux_write_ADDR1 = 3'b010; 
			 	cont_Sig_mux_write_data1 = 2'b01; 
			 	RF_en = 1'b1; 
			 	
				begin
				if(IR[4:6]==3'b111)
				cont_Sig_mux_ALUsrcA = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcA = 3'b000;
				end
				
				begin
				
				if(IR[7:9]==3'b111)
				cont_Sig_mux_ALUsrcB = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcB = 3'b000;
				end
				 
			 	
				
				add_enable = 1'b0; 
			 	setZero = 1'b1; 
			 	setCarry = 1'b1; 
			 	cont_Sig_mux_mem_addr = 1'bx; 
				cont_Sig_mux_mem_wdata =1'b0;
			 	mem_en = 1'b0; 
			 	read_wbar = 1'bx; 
			 	IRwrite = 1'b0; 	
				pcwrite=1'b0;
			   end			    


	
			4: begin	//Add immediate
			   cont_Sig_mux_read_ADDR1 = 2'bxx; 
			 	cont_Sig_mux_write_ADDR1 = 3'b001; 
			 	cont_Sig_mux_write_data1 = 2'b01; 
			 	RF_en = 1'b1; 
			 	 
				begin
				if(IR[4:6]==3'b111)
				cont_Sig_mux_ALUsrcA = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcA = 3'b000;
				end
				
				
				cont_Sig_mux_ALUsrcB = 3'b010; 
			 	add_enable = 1'b0; 
			 	setZero = 1'b1; 
			 	setCarry = 1'b1; 
			 	cont_Sig_mux_mem_addr = 1'bx; 
				cont_Sig_mux_mem_wdata =1'b0;
			 	mem_en = 1'b0; 
			 	read_wbar = 1'bx; 
			 	IRwrite = 1'b0; 	
				pcwrite=1'b0;
		   	end
			
		  5:  begin   //Load Immediate
			 	cont_Sig_mux_read_ADDR1 = 2'bxx; 
			 	cont_Sig_mux_write_ADDR1 = 3'b000; 
			 	cont_Sig_mux_write_data1 = 2'b00; 
			 	RF_en = 1'b1; 
			 	cont_Sig_mux_ALUsrcA = 3'bxxx; 
			 	cont_Sig_mux_ALUsrcB = 3'bxxx; 
			 	add_enable = 1'b0; 
			 	setZero = 1'b0; 
			 	setCarry = 1'b0; 
			 	cont_Sig_mux_mem_addr = 1'bx; 
				cont_Sig_mux_mem_wdata =1'b0;
			 	mem_en = 1'b0; 
			 	read_wbar = 1'bx; 
			 	IRwrite = 1'b0; 	
				pcwrite=1'b0;
			   end

			6:  begin   //load word				     
				 cont_Sig_mux_read_ADDR1 = 2'bxx;
				 cont_Sig_mux_write_ADDR1 = 3'bxxx;
				 cont_Sig_mux_write_data1 = 2'bxx; 
				 RF_en = 1'b0; 
				 cont_Sig_mux_ALUsrcA = 3'b001;
				 
				begin
				if(IR[7:9]==3'b111)
				cont_Sig_mux_ALUsrcB = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcB = 3'b000;
				end
				 
				 add_enable = 1'b1;
				 setZero = 1'b0; 
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx; 
				 cont_Sig_mux_mem_wdata =1'b0;
				 mem_en = 1'b0;
				 read_wbar = 1'bx;
				 IRwrite = 1'b0; 
				 pcwrite=1'b0;
			    end
				 
		 13:  begin	//Load Word SubState
				cont_Sig_mux_read_ADDR1 = 2'bxx; 
				cont_Sig_mux_write_ADDR1 = 3'b000; 
				cont_Sig_mux_write_data1 = 2'b11;
				RF_en = 1'b1; 
				cont_Sig_mux_ALUsrcA = 3'bxxx; 
				cont_Sig_mux_ALUsrcB = 3'bxxx; 
				add_enable = 1'b0; 
				setZero = 1'b0;
				setCarry = 1'b0;
				cont_Sig_mux_mem_addr = 1'b1; 
				cont_Sig_mux_mem_wdata =1'b0;
				mem_en = 1'b1; 
				read_wbar = 1'b1;
				IRwrite = 1'b0; 
				pcwrite=1'b0;
			   end	 
				
		  7:  begin	//Store word
				cont_Sig_mux_read_ADDR1 = 2'bxx; 
				cont_Sig_mux_write_ADDR1 = 3'bxxx; 
				cont_Sig_mux_write_data1 = 2'bxx; 
				RF_en = 1'b0; 
				cont_Sig_mux_ALUsrcA = 3'b001; 
					
				begin
				if(IR[7:9]==3'b111)
				cont_Sig_mux_ALUsrcB = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcB = 3'b000;
				end
				 
				
				add_enable = 1'b1; 
				setZero = 1'b0; 
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'bx; 
				cont_Sig_mux_mem_wdata =1'b0;
				mem_en = 1'b0; 
				read_wbar = 1'bx; 
				IRwrite = 1'b0; 
				pcwrite=1'b0;
				end

		  8:  begin	//load multiple
				cont_Sig_mux_read_ADDR1 = 2'b00; // read ra at RF_read1
				cont_Sig_mux_write_ADDR1 = 3'b100; // select priority encoder output at write address of RF
				cont_Sig_mux_write_data1 = 2'b11; // select data output from memory at RF data input
				RF_en = |(IR[8:15]); // write in RF only if there was at least one non-zero bit in the 8 bit imm
				
				
				begin											// select the output of regA or PC at ALU_srcA 
				if(IR[4:6]==3'b111)
				cont_Sig_mux_ALUsrcA = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcA = 3'b000;
				end 
				
				cont_Sig_mux_ALUsrcB = 3'b011; // select +1 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'b0; // select RF_read1 as address for memory
				
				 
	         begin
				if(IR[4:6]==3'b111)
				cont_Sig_mux_mem_wdata = 1'b1; 
			 	else
				cont_Sig_mux_mem_wdata = 1'b0;
				end
				
				
				mem_en = 1'b1;
				read_wbar = 1'b1; 
				IRwrite = 1'b0;
				pcwrite=1'b0;
				cont_Sig_multiple_enable = 1'b1;
			   end

		  9:  begin	//store multiple
				cont_Sig_mux_read_ADDR1 = 2'bxx;
				cont_Sig_mux_write_ADDR1 = 3'bxxx;
				cont_Sig_mux_write_data1 = 2'bxx;
				RF_en = 1'b0; // write in RF only if there was at least one non-zero bit in the 8 bit imm
				
				begin											// select the output of regA or PC at ALU_srcA 
				if(IR[4:6]==3'b111)
				cont_Sig_mux_ALUsrcA = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcA = 3'b000;
				end 
				
				cont_Sig_mux_ALUsrcB = 3'b100; // select 0 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0; 
				cont_Sig_mux_mem_addr = 1'bx; // select RF_read1 as address for memory
				cont_Sig_mux_mem_wdata = 1'b0;
				mem_en = 1'b0;
				read_wbar = 1'bx; 
				IRwrite = 1'b0;
				pcwrite=1'b0;
				cont_Sig_multiple_enable = 1'b0;
			   end
			
		  14:  begin	//Store Word Sub State	
				 cont_Sig_mux_read_ADDR1 = 2'b00; 
				 cont_Sig_mux_write_ADDR1 = 3'bxxx; 
				 cont_Sig_mux_write_data1 = 2'bxx; 
				 RF_en = 1'b0;
				 cont_Sig_mux_ALUsrcA = 3'bxxx; 
				 cont_Sig_mux_ALUsrcB = 3'bxxx; 
				 add_enable = 1'b0; 
				 setZero = 1'b0; 
				 setCarry = 1'b0; 
				 cont_Sig_mux_mem_addr = 1'b1; 
				 
	         begin
				if(IR[4:6]==3'b111)
				cont_Sig_mux_mem_wdata = 1'b1; 
			 	else
				cont_Sig_mux_mem_wdata = 1'b0;
				end
				
				 
				 mem_en = 1'b1; 
				 read_wbar = 1'b0; 
				 IRwrite = 1'b0; 
				 pcwrite=1'b0;			
				 end		
	
		  10:  begin		
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'bxxx; 
				 cont_Sig_mux_write_data1 = 2'bxx; 
				 RF_en = 1'b0; 
				 
				 
				 begin
				if(IR[4:6]==3'b111)
				cont_Sig_mux_ALUsrcA = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcA = 3'b000;
				end
				
				begin
				
				if(IR[7:9]==3'b111)
				cont_Sig_mux_ALUsrcB = 3'b111; 
			 	else
				cont_Sig_mux_ALUsrcB = 3'b000;
				end
				 
				 
				 
				 add_enable = 1'b0; 
				 setZero = 1'b0; 
				 setCarry = 1'b0; 
				 cont_Sig_mux_mem_addr = 1'bx; 
				 cont_Sig_mux_mem_wdata =1'b0;
				 mem_en = 1'b0; 
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0; 
				 pcwrite=1'b0;				 
				 end

          
		  15:  begin		
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
				 cont_Sig_mux_mem_wdata =1'b0;
				 mem_en = 1'b0; 
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0; 
				 pcwrite=1'b0;				 
			    end


	     11:  begin	     //JAL
			 	 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b000;	// write PC+1 in ra
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b110; // enable RF and select PC at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b011; 	// select +1 at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 cont_Sig_mux_mem_wdata = 1'b0;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=1'b0;
				 end

		  12:  begin	//JLR substrate
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b000;	// write PC+1 in ra
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b111; // enable RF and select PC at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b011; 	// select +1 at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 cont_Sig_mux_mem_wdata =1'b0;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=1'b0;
				 end
				

		  16:	 begin  //JAL substate
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b011;	// write PC+Imm in R7
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b110; // enable RF and select PC at ALU_srcA
				 cont_Sig_mux_ALUsrcB = 3'b001; 	// select extend9 at ALU_srcB
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 cont_Sig_mux_mem_wdata = 1'b0;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite=1'b0;
				 end

		  17:  begin	//JLR substate
				 cont_Sig_mux_read_ADDR1 = 2'bxx; 
				 cont_Sig_mux_write_ADDR1 = 3'b011;	// write rb in R7
				 cont_Sig_mux_write_data1 = 2'b01;	// write data from ALU_async
				 RF_en = 1'b1; cont_Sig_mux_ALUsrcA = 3'b100; // enable RF and select +0 at ALU_srcA
				 
				begin
				if(IR[7:9]==3'b111)
				cont_Sig_mux_ALUsrcB = 3'b111; // select regB at ALU_srcB
			 	else
				cont_Sig_mux_ALUsrcB = 3'b000;
				end
				 
				  	
				 add_enable = 1'b1;			// enable addition in ALU
				 setZero = 1'b0;
				 setCarry = 1'b0;
				 cont_Sig_mux_mem_addr = 1'bx;
				 cont_Sig_mux_mem_wdata = 1'b0;
				 mem_en = 1'b0;
				 read_wbar = 1'bx; 
				 IRwrite = 1'b0;
				 pcwrite = 1'b0;
				 end

		 18:  begin	//load multiple substate
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
				cont_Sig_mux_mem_wdata = 1'b0;
				mem_en = 1'b1;
				read_wbar = 1'b1; 
				IRwrite = 1'b0;
				pcwrite = 1'b0;
				cont_Sig_multiple_enable = 1'b1;
			   end

		 19:  begin	//store multiple substate
				cont_Sig_mux_read_ADDR1 = 2'b10;
				cont_Sig_mux_write_ADDR1 = 3'bxxx;
				cont_Sig_mux_write_data1 = 2'bxx;
				RF_en = 1'b0;
				cont_Sig_mux_ALUsrcA = 3'b101; // select ALU_result at ALU_srcA
				cont_Sig_mux_ALUsrcB = 3'b011; // select +1 at ALU_srcB
				add_enable = 1'b1;
				setZero = 1'b0;
				setCarry = 1'b0;
				cont_Sig_mux_mem_addr = 1'b1; // select ALU_result as address for memory
				//
				cont_Sig_mux_mem_wdata =1'b0;
				mem_en = ~flag_multiple;
				read_wbar = 1'b0;
				IRwrite = 1'b0;
				pcwrite = 1'b0;
				cont_Sig_multiple_enable = 1'b1;
			   end
			
			endcase
		end
end

always@(IR or carry_flag or zero_flag or reset or StateID or flag_multiple or beq_flag)
 begin
     if(reset)
			begin
			nextStateID = 0;
			end
	  else
			begin
			case(StateID)
		
		   0:  begin
				 nextStateID = 1;
				 end
			
			1:  begin 
				 nextStateID = 2;
				 
				 end

			2:  begin
				 case(IR[0:3])
				 
					4'b0000:   begin //ADD
							    
								 
								 
								  if(IR[14:15]==2'b00)							  
									  begin
									  nextStateID = 3;
									  end
									  
								  else
								  if(IR[14:15]==2'b10 && carry_flag==1)							 
									  begin
									  nextStateID = 3;
									  end
								  
								  else
								  if(IR[14:15]==2'b10 && carry_flag==0)							 
									  begin
									  nextStateID = 1;
									  end
								  
								  else
								  if (IR[14:15]==2'b01 && zero_flag==1)
									  begin
									  nextStateID = 3;
									  end
								  
								  else
								  if(IR[14:15]==2'b01 && zero_flag==0)
									  begin
									  nextStateID = 1;
									  end
								  
							     end
							  
					4'b0001:   begin			    			//Add immediate
					
								 					
								  nextStateID =4; 
								  end
						
						
					4'b0010:   begin							//NAND instruction 
								 
								
								
							     if(IR[14:15]==00)							  
									  begin
									  nextStateID = 3;
									  end
						    
								  else
								  if(IR[14:15]==2'b10 && carry_flag==1)							 
									  begin
									  nextStateID = 3;
									  end
							  
								  else
								  if(IR[14:15]==2'b10 && carry_flag==0)							 
									  begin
									  nextStateID = 1;
									  end
							  
								  else
								  if (IR[14:15]==2'b01 && zero_flag==1)
									  begin
									  nextStateID = 3;
									  end
							  
								  else
								  if(IR[14:15]==2'b01 && zero_flag==0)
									  begin
									  nextStateID = 1;
									  end
									  
								  end
							
							
				
					4'b0011:   begin
								  nextStateID = 5;				//Load Immediate
								  end
								  
					4'b0100:   begin
					        
								  nextStateID = 6;				//Load Word
								  end
								  
					4'b0101:   begin
					          
								  nextStateID = 7;				//Store Word
							     end	  
					  
					4'b0110:   begin
								  nextStateID = 8;				//LM
								  end
								  
					4'b0111:   begin
								  nextStateID = 9;				//SM
								  end
								  
					4'b1100:   begin
								  nextStateID = 10;			   	//BEQ
								  end
								  
					4'b1000:   begin
								  nextStateID = 11;				//JAL
								  end
								  
					4'b1001:   begin
								  nextStateID = 12;				//JLR
    							  end
					endcase
			   end	

			3:  begin                                //Add and NAND
			 	 nextStateID = 1;
			    end			    
	
			4:  begin	//Add immediate
			    nextStateID = 1;
			    end
			
			5:  begin   //Load Immediate
			 	 nextStateID = 1;
			    end

			6:  begin   //load word	
			    nextStateID = 13;
			    end
				 
			13: begin   //Load Word SubState
				 nextStateID = 1;
             end	 
				
			7:  begin    //Store word

				 nextStateID = 14;
			    end

			8:  begin
			    if(~flag_multiple)
					nextStateID = 18;
				 else
					nextStateID = 1;
				 end

			9:  begin
				 nextStateID = 19;
			    end
			
			14: begin  //Store Word Sub State	
				 nextStateID = 1;
      		 end
			
			10: begin			
			    if(beq_flag)
					nextStateID = 15;     //beq nextState
				 else
		      	nextStateID =	1;
				 end
			
			11: begin 
					nextStateID = 16;
			    end
	 
			12: begin
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
			        begin
					  if(flag_multiple) 
						nextStateID = 1; 
					  else 
						nextStateID = 18;
					  end
			    end

			19: begin
					  if(flag_multiple) 
						nextStateID = 1; 
					  else 
						nextStateID = 19;
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
