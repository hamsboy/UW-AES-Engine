module AES(input [127:0] key,input keyLen,input validIn,
          input   [31:0] rnum,input clk,
          output validOut, output wire [127:0] outKey);
			 
			 wire [31:0] w0,w1,w2,w3,temp,sub;
			 reg [31:0] rcon;
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
		 
		  
			//assign sub=32'h6238bbf6;
			 //find Rcon value
			 
//			 always @ (rnum)
//			 begin
//				 case (rnum)
//					  4'h1: rcon=32'h01000000;
//					  4'h2: rcon=32'h02000000;
//					  4'h3: rcon=32'h04000000;
//					  4'h4: rcon=32'h08000000;
//					  4'h5: rcon=32'h10000000;
//					  4'h6: rcon=32'h20000000;
//					  4'h7: rcon=32'h40000000;
//					  4'h8: rcon=32'h80000000;
//					  4'h9: rcon=32'h1b000000;
//					  4'ha: rcon=32'h36000000;
//					  default: rcon=32'h00000000;
//				 endcase
//			 end
//			
			 

		       
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

///=============================================================================================================================
//module Round1 (input [127:0] key,input clk,input [3:0] rnum,input keyLen,input validIn, input validOut, input [127:0] data, output  [127:0] dataOut, output [127:0] keyOut);
//       wire [127:0] sb,sr,mc,r4;
//		 
//		 SubByte1 sub (.state(data),.state_out(sb));
//		 Shiftrow1  shift(.sb(sb),.sr(sr));
//		 MixColumn1 mix (.in_byte(sr),.out_byte(mc));
//		 
//		 AES aes1 (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.clk(clk),.validOut(validOut),.outKey(keyOUt));
//		  
//		 assign dataOut=mc^keyOut;	
//       
//endmodule 







module SubByte1 (input wire [127:0] state, output wire  [127:0]state_out);



genvar itr;
generate
		for (itr = 0 ; itr <= 127; itr = itr+8) begin :s
					sbox sb (.sbox_data_in(state[itr +:8]) , .sbox_data_out(state_out[itr +:8]));
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


module MixColumn1(in_byte, out_byte);
	input [127:0] in_byte;
	output wire [127:0] out_byte;
	
	assign out_byte[127:120] = mul2(in_byte[127:120])^mul3(in_byte[119:112])^(in_byte[111:104])^(in_byte[103:96]);
	assign out_byte[119:112] = (in_byte[127:120])^mul2(in_byte[119:112])^mul3(in_byte[111:104])^(in_byte[103:96]);
	assign out_byte[111:104] = (in_byte[127:120])^(in_byte[119:112])^mul2(in_byte[111:104])^mul3(in_byte[103:96]);
	assign out_byte[103:96]  = mul3(in_byte[127:120])^(in_byte[119:112])^(in_byte[111:104])^mul2(in_byte[103:96]);
	
	assign out_byte[95:88] = mul2(in_byte[95:88])^mul3(in_byte[87:80])^(in_byte[79:72])^(in_byte[71:64]);
	assign out_byte[87:80] = (in_byte[95:88])^mul2(in_byte[87:80])^mul3(in_byte[79:72])^(in_byte[71:64]);
	assign out_byte[79:72] = (in_byte[95:88])^(in_byte[87:80])^mul2(in_byte[79:72])^mul3(in_byte[71:64]);
	assign out_byte[71:64]  = mul3(in_byte[95:88])^(in_byte[87:80])^(in_byte[79:72])^mul2(in_byte[71:64]);
	
	assign out_byte[63:56] = mul2(in_byte[63:56])^mul3(in_byte[55:48])^(in_byte[47:40])^(in_byte[39:32]);
	assign out_byte[55:48] = (in_byte[63:56])^mul2(in_byte[55:48])^mul3(in_byte[47:40])^(in_byte[39:32]);
	assign out_byte[47:40] = (in_byte[63:56])^(in_byte[55:48])^mul2(in_byte[47:40])^mul3(in_byte[39:32]);
	assign out_byte[39:32]  = mul3(in_byte[63:56])^(in_byte[55:48])^(in_byte[47:40])^mul2(in_byte[39:32]);
	
	assign out_byte[31:24] = mul2(in_byte[31:24])^mul3(in_byte[23:16])^(in_byte[15:8])^(in_byte[7:0]);
	assign out_byte[23:16] = (in_byte[31:24])^mul2(in_byte[23:16])^mul3(in_byte[15:8])^(in_byte[7:0]);
	assign out_byte[15:8] = (in_byte[31:24])^(in_byte[23:16])^mul2(in_byte[15:8])^mul3(in_byte[7:0]);
	assign out_byte[7:0]  = mul3(in_byte[31:24])^(in_byte[23:16])^(in_byte[15:8])^mul2(in_byte[7:0]);
	
	
		

// This function stores the tables holding the results of performing 
// the multiplication in GF(256) of any number by 0x 02

function [7:0] mul2;
	input [7:0] x;
	case (x)
		8'h00 : mul2 = 8'h00;
      8'h01 : mul2 = 8'h02;
      8'h02 : mul2 = 8'h04;
      8'h03 : mul2 = 8'h06;
      8'h04 : mul2 = 8'h08;
      8'h05 : mul2 = 8'h0A;
      8'h06 : mul2 = 8'h0C;
      8'h07 : mul2 = 8'h0E;
		
      8'h08 : mul2 = 8'h10;
      8'h09 : mul2 = 8'h12;
      8'h0A : mul2 = 8'h14;
      8'h0B : mul2 = 8'h16;
      8'h0C : mul2 = 8'h18;
      8'h0D : mul2 = 8'h1A;
      8'h0E : mul2 = 8'h1C;
      8'h0F : mul2 = 8'h1E;
		
      8'h10 : mul2 = 8'h20;
      8'h11 : mul2 = 8'h22;
      8'h12 : mul2 = 8'h24;
      8'h13 : mul2 = 8'h26;
      8'h14 : mul2 = 8'h28;
      8'h15 : mul2 = 8'h2A;
      8'h16 : mul2 = 8'h2C;
      8'h17 : mul2 = 8'h2E;
		
      8'h18 : mul2 = 8'h30;
      8'h19 : mul2 = 8'h32;
      8'h1A : mul2 = 8'h34;
      8'h1B : mul2 = 8'h36;
      8'h1C : mul2 = 8'h38;
      8'h1D : mul2 = 8'h3A;
      8'h1E : mul2 = 8'h3C;
      8'h1F : mul2 = 8'h3E;
		
      8'h20 : mul2 = 8'h40;
      8'h21 : mul2 = 8'h42;
      8'h22 : mul2 = 8'h44;
      8'h23 : mul2 = 8'h46;
      8'h24 : mul2 = 8'h48;
      8'h25 : mul2 = 8'h4A;
      8'h26 : mul2 = 8'h4C;
      8'h27 : mul2 = 8'h4E;
		
      8'h28 : mul2 = 8'h50;
      8'h29 : mul2 = 8'h52;
      8'h2A : mul2 = 8'h54;
      8'h2B : mul2 = 8'h56;
      8'h2C : mul2 = 8'h58;
      8'h2D : mul2 = 8'h5A;
      8'h2E : mul2 = 8'h5C;
      8'h2F : mul2 = 8'h5E;
		
      8'h30 : mul2 = 8'h60;
      8'h31 : mul2 = 8'h62;
      8'h32 : mul2 = 8'h64;
      8'h33 : mul2 = 8'h66;
      8'h34 : mul2 = 8'h68;
      8'h35 : mul2 = 8'h6A;
      8'h36 : mul2 = 8'h6C;
      8'h37 : mul2 = 8'h6E;
		
      8'h38 : mul2 = 8'h70;
      8'h39 : mul2 = 8'h72;
      8'h3A : mul2 = 8'h74;
      8'h3B : mul2 = 8'h76;
      8'h3C : mul2 = 8'h78;
      8'h3D : mul2 = 8'h7A;
      8'h3E : mul2 = 8'h7C;
      8'h3F : mul2 = 8'h7E;
		
      8'h40 : mul2 = 8'h80;
      8'h41 : mul2 = 8'h82;
      8'h42 : mul2 = 8'h84;
      8'h43 : mul2 = 8'h86;
      8'h44 : mul2 = 8'h88;
      8'h45 : mul2 = 8'h8A;
      8'h46 : mul2 = 8'h8C;
      8'h47 : mul2 = 8'h8E;
		
      8'h48 : mul2 = 8'h90;
      8'h49 : mul2 = 8'h92;
      8'h4A : mul2 = 8'h94;
      8'h4B : mul2 = 8'h96;
      8'h4C : mul2 = 8'h98;
      8'h4D : mul2 = 8'h9A;
      8'h4E : mul2 = 8'h9C;
      8'h4F : mul2 = 8'h9E;
		
      8'h50 : mul2 = 8'hA0;
      8'h51 : mul2 = 8'hA2;
      8'h52 : mul2 = 8'hA4;
      8'h53 : mul2 = 8'hA6;
      8'h54 : mul2 = 8'hA8;
      8'h55 : mul2 = 8'hAA;
      8'h56 : mul2 = 8'hAC;
      8'h57 : mul2 = 8'hAE;
		
      8'h58 : mul2 = 8'hB0;
      8'h59 : mul2 = 8'hB2;
      8'h5A : mul2 = 8'hB4;
      8'h5B : mul2 = 8'hB6;
      8'h5C : mul2 = 8'hB8;
      8'h5D : mul2 = 8'hBA;
      8'h5E : mul2 = 8'hBC;
      8'h5F : mul2 = 8'hBE;
		
      8'h60 : mul2 = 8'hC0;
      8'h61 : mul2 = 8'hC2;
      8'h62 : mul2 = 8'hC4;
      8'h63 : mul2 = 8'hC6;
      8'h64 : mul2 = 8'hC8;
      8'h65 : mul2 = 8'hCA;
      8'h66 : mul2 = 8'hCC;
      8'h67 : mul2 = 8'hCE;
		
      8'h68 : mul2 = 8'hD0;
      8'h69 : mul2 = 8'hD2;
      8'h6A : mul2 = 8'hD4;
      8'h6B : mul2 = 8'hD6;
      8'h6C : mul2 = 8'hD8;
      8'h6D : mul2 = 8'hDA;
      8'h6E : mul2 = 8'hDC;
      8'h6F : mul2 = 8'hDE;
		
      8'h70 : mul2 = 8'hE0;
      8'h71 : mul2 = 8'hE2;
      8'h72 : mul2 = 8'hE4;
      8'h73 : mul2 = 8'hE6;
      8'h74 : mul2 = 8'hE8;
      8'h75 : mul2 = 8'hEA;
      8'h76 : mul2 = 8'hEC;
      8'h77 : mul2 = 8'hEE;
		
      8'h78 : mul2 = 8'hF0;
      8'h79 : mul2 = 8'hF2;
      8'h7A : mul2 = 8'hF4;
      8'h7B : mul2 = 8'hF6;
      8'h7C : mul2 = 8'hF8;
      8'h7D : mul2 = 8'hFA;
      8'h7E : mul2 = 8'hFC;
      8'h7F : mul2 = 8'hFE;
		
      8'h80 : mul2 = 8'h1B;
      8'h81 : mul2 = 8'h19;
      8'h82 : mul2 = 8'h1F;
      8'h83 : mul2 = 8'h1D;
      8'h84 : mul2 = 8'h13;
      8'h85 : mul2 = 8'h11;
      8'h86 : mul2 = 8'h17;
      8'h87 : mul2 = 8'h15;
		
      8'h88 : mul2 = 8'h0B;
      8'h89 : mul2 = 8'h09;
      8'h8A : mul2 = 8'h0F;
      8'h8B : mul2 = 8'h0D;
      8'h8C : mul2 = 8'h03;
      8'h8D : mul2 = 8'h01;
      8'h8E : mul2 = 8'h07;
      8'h8F : mul2 = 8'h05;
		
      8'h90 : mul2 = 8'h3B;
      8'h91 : mul2 = 8'h39;
      8'h92 : mul2 = 8'h3F;
      8'h93 : mul2 = 8'h3D;
      8'h94 : mul2 = 8'h33;
      8'h95 : mul2 = 8'h31;
      8'h96 : mul2 = 8'h37;
      8'h97 : mul2 = 8'h35;
		
      8'h98 : mul2 = 8'h2B;
      8'h99 : mul2 = 8'h29;
      8'h9A : mul2 = 8'h2F;
      8'h9B : mul2 = 8'h2D;
      8'h9C : mul2 = 8'h23;
      8'h9D : mul2 = 8'h21;
      8'h9E : mul2 = 8'h27;
      8'h9F : mul2 = 8'h25;
		
      8'hA0 : mul2 = 8'h5B;
      8'hA1 : mul2 = 8'h59;
      8'hA2 : mul2 = 8'h5F;
      8'hA3 : mul2 = 8'h5D;
      8'hA4 : mul2 = 8'h53;
      8'hA5 : mul2 = 8'h51;
      8'hA6 : mul2 = 8'h57;
      8'hA7 : mul2 = 8'h55;
		
      8'hA8 : mul2 = 8'h4B;
      8'hA9 : mul2 = 8'h49;
      8'hAA : mul2 = 8'h4F;
      8'hAB : mul2 = 8'h4D;
      8'hAC : mul2 = 8'h43;
      8'hAD : mul2 = 8'h41;
      8'hAE : mul2 = 8'h47;
      8'hAF : mul2 = 8'h45;
		
      8'hB0 : mul2 = 8'h7B;
      8'hB1 : mul2 = 8'h79;
      8'hB2 : mul2 = 8'h7F;
      8'hB3 : mul2 = 8'h7D;
      8'hB4 : mul2 = 8'h73;
      8'hB5 : mul2 = 8'h71;
      8'hB6 : mul2 = 8'h77;
      8'hB7 : mul2 = 8'h75;
		
      8'hB8 : mul2 = 8'h6B;
      8'hB9 : mul2 = 8'h69;
      8'hBA : mul2 = 8'h6F;
      8'hBB : mul2 = 8'h6D;
      8'hBC : mul2 = 8'h63;
      8'hBD : mul2 = 8'h61;
      8'hBE : mul2 = 8'h67;
      8'hBF : mul2 = 8'h65;
		
      8'hC0 : mul2 = 8'h9B;
      8'hC1 : mul2 = 8'h99;
      8'hC2 : mul2 = 8'h9F;
      8'hC3 : mul2 = 8'h9D;
      8'hC4 : mul2 = 8'h93;
      8'hC5 : mul2 = 8'h91;
      8'hC6 : mul2 = 8'h97;
      8'hC7 : mul2 = 8'h95;
		
      8'hC8 : mul2 = 8'h8B;
      8'hC9 : mul2 = 8'h89;
      8'hCA : mul2 = 8'h8F;
      8'hCB : mul2 = 8'h8D;
      8'hCC : mul2 = 8'h83;
      8'hCD : mul2 = 8'h81;
      8'hCE : mul2 = 8'h87;
      8'hCF : mul2 = 8'h85;
		
      8'hD0 : mul2 = 8'hBB;
      8'hD1 : mul2 = 8'hB9;
      8'hD2 : mul2 = 8'hBF;
      8'hD3 : mul2 = 8'hBD;
      8'hD4 : mul2 = 8'hB3;
      8'hD5 : mul2 = 8'hB1;
      8'hD6 : mul2 = 8'hB7;
      8'hD7 : mul2 = 8'hB5;
		
      8'hD8 : mul2 = 8'hAB;
      8'hD9 : mul2 = 8'hA9;
      8'hDA : mul2 = 8'hAF;
      8'hDB : mul2 = 8'hAD;
      8'hDC : mul2 = 8'hA3;
      8'hDD : mul2 = 8'hA1;
      8'hDE : mul2 = 8'hA7;
      8'hDF : mul2 = 8'hA5;
		
      8'hE0 : mul2 = 8'hDB;
      8'hE1 : mul2 = 8'hD9;
      8'hE2 : mul2 = 8'hDF;
      8'hE3 : mul2 = 8'hDD;
      8'hE4 : mul2 = 8'hD3;
      8'hE5 : mul2 = 8'hD1;
      8'hE6 : mul2 = 8'hD7;
      8'hE7 : mul2 = 8'hD5;
		
      8'hE8 : mul2 = 8'hCB;
      8'hE9 : mul2 = 8'hC9;
      8'hEA : mul2 = 8'hCF;
      8'hEB : mul2 = 8'hCD;
      8'hEC : mul2 = 8'hC3;
      8'hED : mul2 = 8'hC1;
      8'hEE : mul2 = 8'hC7;
      8'hEF : mul2 = 8'hC5;
		
      8'hF0 : mul2 = 8'hFB;
      8'hF1 : mul2 = 8'hF9;
      8'hF2 : mul2 = 8'hFF;
      8'hF3 : mul2 = 8'hFD;
      8'hF4 : mul2 = 8'hF3;
      8'hF5 : mul2 = 8'hF1;
      8'hF6 : mul2 = 8'hF7;
      8'hF7 : mul2 = 8'hF5;
		
      8'hF8 : mul2 = 8'hEB;
      8'hF9 : mul2 = 8'hE9;
      8'hFA : mul2 = 8'hEF;
      8'hFB : mul2 = 8'hED;
      8'hFC : mul2 = 8'hE3;
      8'hFD : mul2 = 8'hE1;
      8'hFE : mul2 = 8'hE7;
      8'hFF : mul2 = 8'hE5;
		
      default : mul2 = 0;
   endcase
endfunction

// This function stores the tables holding the results of performing 
// the multiplication in GF(256) of any number by 0x 02
function [7:0] mul3;
	input [7:0] x;
	case (x)
		8'h00 : mul3 = 8'h00;
      8'h01 : mul3 = 8'h03;
      8'h02 : mul3 = 8'h06;
      8'h03 : mul3 = 8'h05;
      8'h04 : mul3 = 8'h0C;
      8'h05 : mul3 = 8'h0F;
      8'h06 : mul3 = 8'h0A;
      8'h07 : mul3 = 8'h09;
		
      8'h08 : mul3 = 8'h18;
      8'h09 : mul3 = 8'h1B;
      8'h0A : mul3 = 8'h1E;
      8'h0B : mul3 = 8'h1D;
      8'h0C : mul3 = 8'h14;
      8'h0D : mul3 = 8'h17;
      8'h0E : mul3 = 8'h12;
      8'h0F : mul3 = 8'h11;
		
      8'h10 : mul3 = 8'h30;
      8'h11 : mul3 = 8'h33;
      8'h12 : mul3 = 8'h36;
      8'h13 : mul3 = 8'h35;
      8'h14 : mul3 = 8'h3C;
      8'h15 : mul3 = 8'h3F;
      8'h16 : mul3 = 8'h3A;
      8'h17 : mul3 = 8'h39;
		
      8'h18 : mul3 = 8'h28;
      8'h19 : mul3 = 8'h2B;
      8'h1A : mul3 = 8'h2E;
      8'h1B : mul3 = 8'h2D;
      8'h1C : mul3 = 8'h24;
      8'h1D : mul3 = 8'h27;
      8'h1E : mul3 = 8'h22;
      8'h1F : mul3 = 8'h21;
		
      8'h20 : mul3 = 8'h60;
      8'h21 : mul3 = 8'h63;
      8'h22 : mul3 = 8'h66;
      8'h23 : mul3 = 8'h65;
      8'h24 : mul3 = 8'h6C;
      8'h25 : mul3 = 8'h6F;
      8'h26 : mul3 = 8'h6A;
      8'h27 : mul3 = 8'h69;
		
      8'h28 : mul3 = 8'h78;
      8'h29 : mul3 = 8'h7B;
      8'h2A : mul3 = 8'h7E;
      8'h2B : mul3 = 8'h7D;
      8'h2C : mul3 = 8'h74;
      8'h2D : mul3 = 8'h77;
      8'h2E : mul3 = 8'h72;
      8'h2F : mul3 = 8'h71;
		
      8'h30 : mul3 = 8'h50;
      8'h31 : mul3 = 8'h53;
      8'h32 : mul3 = 8'h56;
      8'h33 : mul3 = 8'h55;
      8'h34 : mul3 = 8'h5C;
      8'h35 : mul3 = 8'h5F;
      8'h36 : mul3 = 8'h5A;
      8'h37 : mul3 = 8'h59;
		
      8'h38 : mul3 = 8'h48;
      8'h39 : mul3 = 8'h4B;
      8'h3A : mul3 = 8'h4E;
      8'h3B : mul3 = 8'h4D;
      8'h3C : mul3 = 8'h44;
      8'h3D : mul3 = 8'h47;
      8'h3E : mul3 = 8'h42;
      8'h3F : mul3 = 8'h41;
		
      8'h40 : mul3 = 8'hC0;
      8'h41 : mul3 = 8'hC3;
      8'h42 : mul3 = 8'hC6;
      8'h43 : mul3 = 8'hC5;
      8'h44 : mul3 = 8'hCC;
      8'h45 : mul3 = 8'hCF;
      8'h46 : mul3 = 8'hCA;
      8'h47 : mul3 = 8'hC9;
		
      8'h48 : mul3 = 8'hD8;
      8'h49 : mul3 = 8'hDB;
      8'h4A : mul3 = 8'hDE;
      8'h4B : mul3 = 8'hDD;
      8'h4C : mul3 = 8'hD4;
      8'h4D : mul3 = 8'hD7;
      8'h4E : mul3 = 8'hD2;
      8'h4F : mul3 = 8'hD1;
		
      8'h50 : mul3 = 8'hF0;
      8'h51 : mul3 = 8'hF3;
      8'h52 : mul3 = 8'hF6;
      8'h53 : mul3 = 8'hF5;
      8'h54 : mul3 = 8'hFC;
      8'h55 : mul3 = 8'hFF;
      8'h56 : mul3 = 8'hFA;
      8'h57 : mul3 = 8'hF9;
		
      8'h58 : mul3 = 8'hE8;
      8'h59 : mul3 = 8'hEB;
      8'h5A : mul3 = 8'hEE;
      8'h5B : mul3 = 8'hED;
      8'h5C : mul3 = 8'hE4;
      8'h5D : mul3 = 8'hE7;
      8'h5E : mul3 = 8'hE2;
      8'h5F : mul3 = 8'hE1;
		
      8'h60 : mul3 = 8'hA0;
      8'h61 : mul3 = 8'hA3;
      8'h62 : mul3 = 8'hA6;
      8'h63 : mul3 = 8'hA5;
      8'h64 : mul3 = 8'hAC;
      8'h65 : mul3 = 8'hAF;
      8'h66 : mul3 = 8'hAA;
      8'h67 : mul3 = 8'hA9;
		
      8'h68 : mul3 = 8'hB8;
      8'h69 : mul3 = 8'hBB;
      8'h6A : mul3 = 8'hBE;
      8'h6B : mul3 = 8'hBD;
      8'h6C : mul3 = 8'hB4;
      8'h6D : mul3 = 8'hB7;
      8'h6E : mul3 = 8'hB2;
      8'h6F : mul3 = 8'hB1;
		
      8'h70 : mul3 = 8'h90;
      8'h71 : mul3 = 8'h93;
      8'h72 : mul3 = 8'h96;
      8'h73 : mul3 = 8'h95;
      8'h74 : mul3 = 8'h9C;
      8'h75 : mul3 = 8'h9F;
      8'h76 : mul3 = 8'h9A;
      8'h77 : mul3 = 8'h99;
		
      8'h78 : mul3 = 8'h88;
      8'h79 : mul3 = 8'h8B;
      8'h7A : mul3 = 8'h8E;
      8'h7B : mul3 = 8'h8D;
      8'h7C : mul3 = 8'h84;
      8'h7D : mul3 = 8'h87;
      8'h7E : mul3 = 8'h82;
      8'h7F : mul3 = 8'h81;
		
      8'h80 : mul3 = 8'h9B;
      8'h81 : mul3 = 8'h98;
      8'h82 : mul3 = 8'h9D;
      8'h83 : mul3 = 8'h9E;
      8'h84 : mul3 = 8'h97;
      8'h85 : mul3 = 8'h94;
      8'h86 : mul3 = 8'h91;
      8'h87 : mul3 = 8'h92;
		
      8'h88 : mul3 = 8'h83;
      8'h89 : mul3 = 8'h80;
      8'h8A : mul3 = 8'h85;
      8'h8B : mul3 = 8'h86;
      8'h8C : mul3 = 8'h8F;
      8'h8D : mul3 = 8'h8C;
      8'h8E : mul3 = 8'h89;
      8'h8F : mul3 = 8'h8A;
		
      8'h90 : mul3 = 8'hAB;
      8'h91 : mul3 = 8'hA8;
      8'h92 : mul3 = 8'hAD;
      8'h93 : mul3 = 8'hAE;
      8'h94 : mul3 = 8'hA7;
      8'h95 : mul3 = 8'hA4;
      8'h96 : mul3 = 8'hA1;
      8'h97 : mul3 = 8'hA2;
		
      8'h98 : mul3 = 8'hB3;
      8'h99 : mul3 = 8'hB0;
      8'h9A : mul3 = 8'hB5;
      8'h9B : mul3 = 8'hB6;
      8'h9C : mul3 = 8'hBF;
      8'h9D : mul3 = 8'hBC;
      8'h9E : mul3 = 8'hB9;
      8'h9F : mul3 = 8'hBA;
		
      8'hA0 : mul3 = 8'hFB;
      8'hA1 : mul3 = 8'hF8;
      8'hA2 : mul3 = 8'hFD;
      8'hA3 : mul3 = 8'hFE;
      8'hA4 : mul3 = 8'hF7;
      8'hA5 : mul3 = 8'hF4;
      8'hA6 : mul3 = 8'hF1;
      8'hA7 : mul3 = 8'hF2;
		
      8'hA8 : mul3 = 8'hE3;
      8'hA9 : mul3 = 8'hE0;
      8'hAA : mul3 = 8'hE5;
      8'hAB : mul3 = 8'hE6;
      8'hAC : mul3 = 8'hEF;
      8'hAD : mul3 = 8'hEC;
      8'hAE : mul3 = 8'hE9;
      8'hAF : mul3 = 8'hEA;
		
      8'hB0 : mul3 = 8'hCB;
      8'hB1 : mul3 = 8'hC8;
      8'hB2 : mul3 = 8'hCD;
      8'hB3 : mul3 = 8'hCE;
      8'hB4 : mul3 = 8'hC7;
      8'hB5 : mul3 = 8'hC4;
      8'hB6 : mul3 = 8'hC1;
      8'hB7 : mul3 = 8'hC2;
		
      8'hB8 : mul3 = 8'hD3;
      8'hB9 : mul3 = 8'hD0;
      8'hBA : mul3 = 8'hD5;
      8'hBB : mul3 = 8'hD6;
      8'hBC : mul3 = 8'hDF;
      8'hBD : mul3 = 8'hDC;
      8'hBE : mul3 = 8'hD9;
      8'hBF : mul3 = 8'hDA;
		
      8'hC0 : mul3 = 8'h5B;
      8'hC1 : mul3 = 8'h58;
      8'hC2 : mul3 = 8'h5D;
      8'hC3 : mul3 = 8'h5E;
      8'hC4 : mul3 = 8'h57;
      8'hC5 : mul3 = 8'h54;
      8'hC6 : mul3 = 8'h51;
      8'hC7 : mul3 = 8'h52;
		
      8'hC8 : mul3 = 8'h43;
      8'hC9 : mul3 = 8'h40;
      8'hCA : mul3 = 8'h45;
      8'hCB : mul3 = 8'h46;
      8'hCC : mul3 = 8'h4F;
      8'hCD : mul3 = 8'h4C;
      8'hCE : mul3 = 8'h49;
      8'hCF : mul3 = 8'h4A;
		
      8'hD0 : mul3 = 8'h6B;
      8'hD1 : mul3 = 8'h68;
      8'hD2 : mul3 = 8'h6D;
      8'hD3 : mul3 = 8'h6E;
      8'hD4 : mul3 = 8'h67;
      8'hD5 : mul3 = 8'h64;
      8'hD6 : mul3 = 8'h61;
      8'hD7 : mul3 = 8'h62;
		
      8'hD8 : mul3 = 8'h73;
      8'hD9 : mul3 = 8'h70;
      8'hDA : mul3 = 8'h75;
      8'hDB : mul3 = 8'h76;
      8'hDC : mul3 = 8'h7F;
      8'hDD : mul3 = 8'h7C;
      8'hDE : mul3 = 8'h79;
      8'hDF : mul3 = 8'h7A;
		
      8'hE0 : mul3 = 8'h3B;
      8'hE1 : mul3 = 8'h38;
      8'hE2 : mul3 = 8'h3D;
      8'hE3 : mul3 = 8'h3E;
      8'hE4 : mul3 = 8'h37;
      8'hE5 : mul3 = 8'h34;
      8'hE6 : mul3 = 8'h31;
      8'hE7 : mul3 = 8'h32;
		
      8'hE8 : mul3 = 8'h23;
      8'hE9 : mul3 = 8'h20;
      8'hEA : mul3 = 8'h25;
      8'hEB : mul3 = 8'h26;
      8'hEC : mul3 = 8'h2F;
      8'hED : mul3 = 8'h2C;
      8'hEE : mul3 = 8'h29;
      8'hEF : mul3 = 8'h2A;
		
      8'hF0 : mul3 = 8'h0B;
      8'hF1 : mul3 = 8'h08;
      8'hF2 : mul3 = 8'h0D;
      8'hF3 : mul3 = 8'h0E;
      8'hF4 : mul3 = 8'h07;
      8'hF5 : mul3 = 8'h04;
      8'hF6 : mul3 = 8'h01;
      8'hF7 : mul3 = 8'h02;
		
      8'hF8 : mul3 = 8'h13;
      8'hF9 : mul3 = 8'h10;
      8'hFA : mul3 = 8'h15;
      8'hFB : mul3 = 8'h16;
      8'hFC : mul3 = 8'h1F;
      8'hFD : mul3 = 8'h1C;
      8'hFE : mul3 = 8'h19;
      8'hFF : mul3 = 8'h1A;
		
      default : mul3 = 0;
	endcase
endfunction
endmodule




//--======================================================

 module Round1 (input [127:0] key,input clk,input [31:0] rnum,input keyLen,input validIn, input validOut, input [127:0] data, output [127:0] dataOut,output [127:0] keyOut);
       wire [127:0] ro1,ro2,ro3,ro4;
		 SubByte1 sub (.state(data),.state_out(ro1));
		 Shiftrow1 shift(.sb(ro1),.sr(ro2));
		 MixColumn1 mix (.in_byte(ro2),.out_byte(ro3));
		 
		 AES aes (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.clk(clk),.validOut(validOut),.outKey(ro4));
		assign dataOut=ro3^ro4;
		 assign keyOut=ro4;
		 
		 //assign dataOut=ro3; //
       
endmodule 


 module LastRound1 (input [127:0] key,input clk,input [31:0] rnum,input keyLen,input validIn, input validOut, input [127:0] data, output [127:0] dataOut,output [127:0] keyOut);
       wire [127:0] ro1,ro2,ro3,ro4;
		 SubByte1 sub (.state(data),.state_out(ro1));
		 Shiftrow1 shift(.sb(ro1),.sr(ro2));
		
		 
		 AES aes (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.clk(clk),.validOut(validOut),.outKey(ro4));
		 assign dataOut=ro2^ro4;
		 assign keyOut=ro4;
       
endmodule 


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
	//wire[31:0] temp,sub;
//	assign temp=32'hD6AB76FE;
//	genvar itr;
//
//			generate
//					for (itr = 0 ; itr <= 31; itr = itr+8) begin :a
//								sbox sb (.sbox_data_in(temp[itr +:8]) , .sbox_data_out(sub[itr +:8]));  
//								end
//			endgenerate
//			

  
 // assign r1=data^key;
  
 
  //Round1 round91 (.key(key), .clk(clk),.rnum(9),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(data), .dataOut(dataOut),.keyOut(outKey));
  
  AESCORE1 core1 (.key(key), .clk(clk),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(data), .dataOut(dataOut),.keyOut(outKey));
  //AES aes (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.clk(clk),.validOut(validOut),.outKey(outKey));
endmodule
