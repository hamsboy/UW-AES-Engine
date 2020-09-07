/*In this version I combined Subyte and mix Column as one Layer
*/

module AES(input [127:0] key,input keyLen,input validIn,
          input   [31:0] rnum,input clk,
          output validOut, output wire [127:0] outKey);
			 
			 wire [31:0] w0,w1,w2,w3,temp,sub;
			
			  reg [127:0] tempOutKey;
			 //split the key into 4 words
			 assign w0=key[127:96];
			 assign w1=key[95:64];
			 assign w2=key[63:32];
			 assign w3=key[31:0];
			 
			 //rotate the last word by one byte(so rotate w3 by  1byte)
			 assign temp={w3[23:0],w3[31:24]};
			// SubByte s(.in(temp),.out(sub));
			 
					 
			genvar itr;

			generate
					for (itr = 0 ; itr <= 31; itr = itr+8) begin :a
								sbox sb (.sbox_data_in(temp[itr +:8]) , .sbox_data_out(sub[itr +:8]));
								end
			endgenerate
		 
		  
	       
         parameter USE_CASE = 1;
			 
			 
	generate
	    
        if (!USE_CASE )   
     
		      assign outKey = 0;
         
            /* donothing */
      
        else 
        
            if(USE_CASE )
               
                assign outKey[127:96]=w0^sub^rnum;
		         assign outKey[95:64]=w0^sub^rnum^w1;
			        assign outKey[63:32]=w0^sub^rnum^w1^w2;
			      assign outKey[31:0]=w0^sub^rnum^w1^w2^w3;
                
       
   endgenerate
						 
endmodule



//==================================================================================================================
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
module MixColumn1(in_byte, out_byte);
	input [127:0] in_byte;
	output wire [127:0] out_byte;
	
  reg [19:0] data_ROM [0:255];
  wire [319:0 ] adress;
  initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
  assign adress[0 +:20]=data_ROM[in_byte[127:120]];
  assign adress[20 +:20]=data_ROM[in_byte[119:112]];
  assign adress[40 +:20]=data_ROM[in_byte[111:104]];
  assign adress[60 +:20]=data_ROM[in_byte[103:96]];
  
     
  assign out_byte[127:120] = ({adress[18:16],adress[11:10],adress[13],adress[9:8]})^(adress[20 +:8])^(adress[52 +:8])^(adress[72 +:8]);
  assign out_byte[119:112] = (adress[12 +:8])^({adress[20+18:20+16],adress[20+11:20+10],adress[20+13],adress[20+9:20+8]})^(adress[40 +:8])^(adress[72 +:8]);
  assign out_byte[111:104] = (adress[12 +:8])^(adress[32 +:8])^({adress[40+18:40+16],adress[40+11:40+10],adress[40+13],adress[40+9:40+8]})^(adress[60+:8]);
  assign out_byte[103:96]  = (adress[0 +:8])^(adress[32+:8])^(adress[52 +:8])^({adress[60+18:60+16],adress[60+11:60+10],adress[60+13],adress[60+9:60+8]});
	
	

	  
  assign adress[80 +:20]= data_ROM[in_byte[95:88]];
  assign adress[100 +:20]=data_ROM[in_byte[87:80]];
  assign adress[120 +:20]=data_ROM[in_byte[79:72]];
  assign adress[140 +:20]=data_ROM[in_byte[71:64]];
  
  
  assign out_byte[95:88] = ({adress[80+18:80+16],adress[80+11:80+10],adress[80+13],adress[80+9:80+8]})^(adress[100 +:8])^(adress[120+12 +:8])^(adress[140+12 +:8]);
  assign out_byte[87:80] = (adress[80+12 +:8])^({adress[100+18:100+16],adress[100+11:100+10],adress[100+13],adress[100+9:100+8]})^(adress[120 +:8])^(adress[140+12 +:8]);
  assign out_byte[79:72] = (adress[80+12 +:8])^(adress[100+12 +:8])^({adress[120+18:120+16],adress[120+11:120+10],adress[120+13],adress[120+9:120+8]})^(adress[140 +:8]);
  assign out_byte[71:64]  = (adress[80 +:8])^(adress[100+12 +:8])^(adress[120+12 +:8])^({adress[140+18:140+16],adress[140+11:140+10],adress[140+13],adress[140+9:140+8]});
  

	
	
  assign adress[160 +:20]= data_ROM[in_byte[63:56]];
  assign adress[180 +:20]=data_ROM[in_byte[55:48]];
  assign adress[200 +:20]=data_ROM[in_byte[47:40]];
  assign adress[220 +:20]=data_ROM[in_byte[39:32]];
  
   
  assign out_byte[63:56] = ({adress[160+18:160+16],adress[160+11:160+10],adress[160+13],adress[160+9:160+8]})^(adress[180 +:8])^(adress[200+12 +:8])^(adress[220+12 +:8]);
  assign out_byte[55:48] = (adress[160+12 +:8])^({adress[180+18:180+16],adress[180+11:180+10],adress[180+13],adress[180+9:180+8]})^(adress[200 +:8])^(adress[220+12 +:8]);
  assign out_byte[47:40] = (adress[160+12 +:8])^(adress[180+12 +:8])^({adress[200+18:200+16],adress[200+11:200+10],adress[200+13],adress[200+9:200+8]})^(adress[220 +:8]);
  assign out_byte[39:32]  = (adress[160 +:8])^(adress[180+12 +:8])^(adress[200+12 +:8])^({adress[220+18:220+16],adress[220+11:220+10],adress[220+13],adress[220+9:220+8]});
	

   assign adress[240 +:20]= data_ROM[in_byte[31:24]];
   assign adress[260 +:20]=data_ROM[in_byte[23:16]];
   assign adress[280 +:20]=data_ROM[in_byte[15:8]];
   assign adress[300 +:20]=data_ROM[in_byte[7:0]];
	
	 
  assign out_byte[31:24] = ({adress[240+18:240+16],adress[240+11:240+10],adress[240+13],adress[240+9:240+8]})^(adress[260 +:8])^(adress[280+12 +:8])^(adress[300+12 +:8]);
  assign out_byte[23:16] = (adress[240+12 +:8])^({adress[260+18:260+16],adress[260+11:260+10],adress[260+13],adress[260+9:260+8]})^(adress[280 +:8])^(adress[300+12 +:8]);
  assign out_byte[15:8]  = (adress[240+12 +:8])^(adress[260+12 +:8])^({adress[280+18:280+16],adress[280+11:280+10],adress[280+13],adress[280+9:280+8]})^(adress[300 +:8]);
  assign out_byte[7:0]  = (adress[240 +:8])^(adress[260+12 +:8])^(adress[280+12 +:8])^({adress[300+18:300+16],adress[300+11:300+10],adress[300+13],adress[300+9:300+8]});
endmodule

//==================================================================================================================

 module Round1 (input [127:0] key,input clk,input [31:0] rnum,input keyLen,input validIn, input validOut, input [127:0] data, output [127:0] dataOut,output [127:0] keyOut);
       wire [127:0] ro1,ro2,ro3,ro4;
		 //SubByte1 sub (.state(data),.state_out(ro1));
		 Shiftrow1 shift(.sb(data),.sr(ro2));
		 MixColumn1 mix (.in_byte(ro2),.out_byte(ro3));
		 
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
	

//		
//		wire [7:0] address;
//		assign address=8'hff;
//		reg [19:0] data_ROM [0:255];
//    wire[19:0] temp;
//    initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
//	 assign temp=data_ROM[address];
//	 
//     always @(address)
//     $display("%h", {temp[18:16],temp[11:10],temp[13],temp[9:8]}); 


		
		
  AESCORE1 core1 (.key(key), .clk(clk),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(data), .dataOut(dataOut),.keyOut(outKey));
endmodule
