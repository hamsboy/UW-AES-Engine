/*In this version I combined Subyte and mix Column as one Layer
*/
module KeyExpansion #(parameter KEY_WIDTH = 128) 
         (input [KEY_WIDTH-1:0] key,input [KEY_WIDTH-1:0] prev_key,
			 input keyLen,input flip,input validIn,
          input	[3:0] rnum,input clk,input reset,
          output reg validOut,output reg [3:0] rnum_out,
			 output reg outflip,output reg [KEY_WIDTH-1:0] outKey);
			 
			
			 reg [31:0] w0,w1,w2,w3,w4;
			 wire [31:0] sub;
	       reg [31:0] temp;
			 reg [KEY_WIDTH-1:0] round_key;
			 //split the key into 4 words


          always @(*) begin
				 if (keyLen) begin  
						w0<=prev_key[127:96];
						w1<=prev_key[95:64];
						w2<=prev_key[63:32];
						w3<=prev_key[31:0];
						w4<=key[31:0];
				 end else begin
				
						w0<=key[127:96];
						w1<=key[95:64];
						w2<=key[63:32];
						w3<=key[31:0];
						w4<=key[31:0];
				  end
			
			 end

		 
			
	     
			genvar itr;

			generate
					for (itr = 0 ; itr <= 31; itr = itr+8) begin :a
								sbox sb (.addr(temp[itr +:8]),.clk(clk),.reset(reset) , .validIn(validIn),.dout(sub[itr +:8]));
								end
			endgenerate
		 
		  
	       
       
			 
				always @(*) begin
							 
									if (!flip) begin  
										 temp<=w4;
										 round_key[127:96]<=w0^sub;
										 round_key[95:64]<=w0^sub^w1;
										 round_key[63:32]<=w0^sub^w1^w2;
										 round_key[31:0]<=w0^sub^w1^w2^w3;
											
										 //update rcon
										 rnum_out<=rnum+1;
									
									end else begin
										  //rotate the last word by one byte(so rotate w3 by  1byte)
										  temp<={w4[23:0],w4[31:24]};
										  
										  round_key[127:96]<=w0^sub^rcon(rnum);
										  round_key[95:64]<=w0^sub^rcon(rnum)^w1;
										  round_key[63:32]<=w0^sub^rcon(rnum)^w1^w2;
										  round_key[31:0]<=w0^sub^rcon(rnum)^w1^w2^w3;
										  rnum_out<=rnum;
									end 
								  
									if (!keyLen)begin
											outflip<=flip;
											rnum_out<=rnum+1;
								  end else begin
											outflip<=!flip;
								  end 
							
					//end
         end
		  
		 always @(posedge clk,negedge reset) begin
					 if(!reset) begin
						outKey<=0;
						validOut<=0;
					 end else begin
					   if(validIn) begin
						 outKey=round_key;
						 
						end
						validOut<=validIn;
				end
				end
						
						
						
		  
		function [31:0]	rcon;
      input	[3:0]	rc;
      case(rc)	
         4'h0: rcon=32'h01_00_00_00;
         4'h1: rcon=32'h02_00_00_00;
         4'h2: rcon=32'h04_00_00_00;
         4'h3: rcon=32'h08_00_00_00;
         4'h4: rcon=32'h10_00_00_00;
         4'h5: rcon=32'h20_00_00_00;
         4'h6: rcon=32'h40_00_00_00;
         4'h7: rcon=32'h80_00_00_00;
         4'h8: rcon=32'h1b_00_00_00;
         4'h9: rcon=32'h36_00_00_00;
         default: rcon=32'h00_00_00_00;
       endcase

     endfunction
		  
		  		 
endmodule


//==================================================================================================================

module SubByte1 (input wire [127:0] state, output wire  [127:0]state_out);


reg [15:0] data_ROM [0:255];

initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 

genvar itr;
generate
		for (itr = 0 ; itr <= 127; itr = itr+8) begin :s
					
      assign state_out[itr +:8]=data_ROM[state[itr+:8]][15:8];
		
	 
					end
 endgenerate
endmodule


module Shiftrow1(sb,sr);

input [127:0] sb;
output wire [127:0] sr;


assign         sr[127:120] = sb[127:120];  
assign         sr[119:112] = sb[87:80];
assign         sr[111:104] = sb[47:40];
assign         sr[103:96]  = sb[7:0];
   
assign          sr[95:88] = sb[95:88];
assign          sr[87:80] = sb[55:48];
assign          sr[79:72] = sb[15:8];
assign          sr[71:64] = sb[103:96];
   
assign          sr[63:56] = sb[63:56];
assign          sr[55:48] = sb[23:16];
assign          sr[47:40] = sb[111:104];
assign          sr[39:32] = sb[71:64];
   
assign          sr[31:24] = sb[31:24];
assign          sr[23:16] = sb[119:112];
assign          sr[15:8]  = sb[79:72];
assign          sr[7:0]   = sb[39:32]; 


endmodule

//==================================================================================================================
/* Subyte and MixColumn*/
module MixColumn_SubByte(in_byte, out_byte);
	input [127:0] in_byte;
	output wire [127:0] out_byte;
	
  reg [15:0] data_ROM [0:255];
 
  initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
 
  //First Column
  assign out_byte[127:120] = ((data_ROM[in_byte[127:120]][15])?((data_ROM[in_byte[127:120]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[127:120]][15:8]<<1))^( data_ROM[in_byte[119:112]][7:0])^( data_ROM[in_byte[111:104]][15:8])^( data_ROM[in_byte[103:96] ][15:8]);
  assign out_byte[119:112] = (data_ROM[in_byte[127:120]][15:8])^( (data_ROM[in_byte[119:112]][15])?((data_ROM[in_byte[119:112]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[119:112]][15:8]<<1) )^( data_ROM[in_byte[111:104]][7:0])^( data_ROM[in_byte[103:96] ][15:8]);
  assign out_byte[111:104] = (data_ROM[in_byte[127:120]][15:8])^(data_ROM[in_byte[119:112] ][15:8])^((data_ROM[in_byte[111:104]][15])?((data_ROM[in_byte[111:104]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[111:104]][15:8]<<1))^( data_ROM[in_byte[103:96]][7:0]);
  assign out_byte[103:96]  = (data_ROM[in_byte[127:120]][7:0])^( data_ROM[in_byte[119:112]][15:8])^( data_ROM[in_byte[111:104]][15:8])^( (data_ROM[in_byte[103:96]][15])?((data_ROM[in_byte[103:96]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[103:96]][15:8]<<1));
	
	
	 //Second Column
  assign  out_byte[95:88]  = ((data_ROM[in_byte[95:88]][15])?((data_ROM[in_byte[95:88]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[95:88]][15:8]<<1))^( data_ROM[in_byte[87:80]][7:0])^( data_ROM[in_byte[79:72]][15:8])^( data_ROM[in_byte[71:64]][15:8]);
  assign out_byte[87:80]  = (data_ROM[in_byte[95:88]][15:8])^( (data_ROM[in_byte[87:80]][15])?((data_ROM[in_byte[87:80]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[87:80]][15:8]<<1) )^( data_ROM[in_byte[79:72]][7:0])^( data_ROM[in_byte[71:64]][15:8]);
  assign out_byte[79:72]  = (data_ROM[in_byte[95:88]][15:8])^(data_ROM[in_byte[87:80] ][15:8])^((data_ROM[in_byte[79:72]][15])?((data_ROM[in_byte[79:72]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[79:72]][15:8]<<1))^( data_ROM[in_byte[71:64]][7:0]);
  assign out_byte[71:64] = (data_ROM[in_byte[95:88]][7:0])^( data_ROM[in_byte[87:80]][15:8])^( data_ROM[in_byte[79:72]][15:8])^( (data_ROM[in_byte[71:64]][15])?((data_ROM[in_byte[71:64]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[71:64]][15:8]<<1));
	
	 //Third Column
  assign out_byte[63:56]  = ((data_ROM[in_byte[63:56]][15])?((data_ROM[in_byte[63:56]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[63:56]][15:8]<<1))^( data_ROM[in_byte[55:48]][7:0])^( data_ROM[in_byte[47:40]][15:8])^( data_ROM[in_byte[39:32]][15:8]);
  assign out_byte[55:48]   = (data_ROM[in_byte[63:56]][15:8])^( (data_ROM[in_byte[55:48]][15])?((data_ROM[in_byte[55:48]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[55:48]][15:8]<<1) )^( data_ROM[in_byte[47:40]][7:0])^( data_ROM[in_byte[39:32]][15:8]);
  assign out_byte[47:40]   = (data_ROM[in_byte[63:56]][15:8])^(data_ROM[in_byte[55:48]][15:8])^((data_ROM[in_byte[47:40]][15])?((data_ROM[in_byte[47:40]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[47:40]][15:8]<<1))^( data_ROM[in_byte[39:32]][7:0]);
  assign out_byte[39:32] = (data_ROM[in_byte[63:56]][7:0])^( data_ROM[in_byte[55:48]][15:8])^( data_ROM[in_byte[47:40]][15:8])^( (data_ROM[in_byte[39:32]][15])?((data_ROM[in_byte[39:32]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[39:32]][15:8]<<1));

  //Fourth Column
  assign  out_byte[31:24]  = ((data_ROM[in_byte[31:24]][15])?((data_ROM[in_byte[31:24]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[31:24]][15:8]<<1))^( data_ROM[in_byte[23:16]][7:0])^( data_ROM[in_byte[15:8]][15:8])^( data_ROM[in_byte[7:0]][15:8]);
  assign out_byte[23:16]   = (data_ROM[in_byte[31:24]][15:8])^( (data_ROM[in_byte[23:16]][15])?((data_ROM[in_byte[23:16]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[23:16]][15:8]<<1) )^( data_ROM[in_byte[15:8]][7:0])^( data_ROM[in_byte[7:0]][15:8]);
  assign out_byte[15:8]   = (data_ROM[in_byte[31:24]][15:8])^(data_ROM[in_byte[23:16]][15:8])^((data_ROM[in_byte[15:8]][15])?((data_ROM[in_byte[15:8]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[15:8]][15:8]<<1))^( data_ROM[in_byte[7:0]][7:0]);
  assign out_byte[7:0] = (data_ROM[in_byte[31:24]][7:0])^( data_ROM[in_byte[23:16]][15:8])^( data_ROM[in_byte[15:8]][15:8])^( (data_ROM[in_byte[7:0]][15])?((data_ROM[in_byte[7:0]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[7:0]][15:8]<<1));
endmodule

//==================================================================================================================

 module Round1 (input [127:0] key,input clk,input [31:0] rnum,input keyLen,input validIn, input validOut, input [127:0] data, output [127:0] dataOut,output [127:0] keyOut);
       wire [127:0] ro2,ro3,ro4;
		 //SubByte1 sub (.state(data),.state_out(ro1));
		 Shiftrow1 shift(.sb(data),.sr(ro2));
		 MixColumn_SubByte mix (.in_byte(ro2),.out_byte(ro3));
		 
		  //key expansion
		 AES aes (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.clk(clk),.validOut(validOut),.outKey(ro4));
		assign dataOut=ro3^ro4;
		 assign keyOut=ro4;
		 
		 //assign dataOut=ro3; //
       
endmodule 


 module LastRound1 (input [127:0] key,input clk,input [31:0] rnum,input keyLen,input validIn, input validOut, input [127:0] data, output [127:0] dataOut,output [127:0] keyOut);
       wire [127:0] ro1,ro2,ro3,ro4;
		 SubByte1 sub (.state(data),.state_out(ro1));
		 Shiftrow1 shift(.sb(ro1),.sr(ro2));
		
		 //key expansion
		 AES aes (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.clk(clk),.validOut(validOut),.outKey(ro4));
		assign dataOut=ro2^ro4;
		//assign dataOut=ro1;
		 assign keyOut=ro4;
       
endmodule 
//==================================================================================================================

module AESCORE1 (input [127:0] key,input clk,input keyLen,input validIn, input validOut, input [127:0] data, output [127:0] dataOut,output [127:0] keyOut);
  wire [127:0] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11;
  wire [127:0] r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  assign r1=data^key;
  Round1 round1 (.key(key), .clk(clk),.rnum(32'h01000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r1), .dataOut(r2),.keyOut(k1));
  Round1 round2 (.key(k1), .clk(clk),.rnum(32'h02000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r2), .dataOut(r3),.keyOut(k2));
  Round1 round3 (.key(k2), .clk(clk),.rnum(32'h04000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r3), .dataOut(r4),.keyOut(k3));
  Round1 round4 (.key(k3), .clk(clk),.rnum(32'h08000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r4), .dataOut(r5),.keyOut(k4));
  Round1 round5 (.key(k4), .clk(clk),.rnum(32'h10000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r5), .dataOut(r6),.keyOut(k5));
  Round1 round6 (.key(k5), .clk(clk),.rnum(32'h20000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r6), .dataOut(r7),.keyOut(k6));
  Round1 round7 (.key(k6), .clk(clk),.rnum(32'h40000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r7), .dataOut(r8),.keyOut(k7));
  Round1 round8 (.key(k7), .clk(clk),.rnum(32'h80000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r8), .dataOut(r9),.keyOut(k8));
  Round1 round9 (.key(k8), .clk(clk),.rnum(32'h1b000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r9), .dataOut(r10),.keyOut(k9));
  
  LastRound1 round10 (.key(k9), .clk(clk),.rnum(32'h36000000),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(r10), .dataOut(r11),.keyOut(k10));

  assign dataOut=r11;
  assign keyOut=k10;
  
endmodule

//=================================================================================================================================================================
module test();
        wire [127:0] key;
	 
	wire keyLen,clk;
	wire validIn; 
	//wire   [3:0] rnum;
        wire validOut;
	wire [127:0] outKey;
	wire[127:0] data; 
	wire[127:0] dataOut;
	
	assign data=128'h00112233445566778899aabbccddeeff;
	assign key=128'h000102030405060708090a0b0c0d0e0f;
	assign rnum=1;
	assign clk=1;
	assign validIn=0;
	assign validOut=1;
	assign keyLen=1;		
	//wire [7:0] address;
	
	//reg [15:0] data_ROM [0:255];
  //wire [255:0 ] adress;
  //initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
  
	//assign address=(data_ROM[8'hff][15])?((data_ROM[8'hff][15:8]<<1) ^ 8'h1b):(data_ROM[8'hff][15:8]<<1); 
  AESCORE1 core1 (.key(key), .clk(clk),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(data), .dataOut(dataOut),.keyOut(outKey));
endmodule
