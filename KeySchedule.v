/* Hamidou Diallo 
7/15/2020
This program expends a single key (128-bits)
*/

module KeySchedule(input [127:0] key,input keyLen,input validIn,
          input   [3:0] rnum,
          output validOut, output [127:0] outKey);
			 
			 wire [31:0] w0,w1,w2,w3,temp,sub;
			 reg [31:0] rcon;
			 
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
			 
			 always @ (rnum)
			 begin
				 case (rnum)
					  4'h1: rcon=32'h01000000;
					  4'h2: rcon=32'h02000000;
					  4'h3: rcon=32'h04000000;
					  4'h4: rcon=32'h08000000;
					  4'h5: rcon=32'h10000000;
					  4'h6: rcon=32'h20000000;
					  4'h7: rcon=32'h40000000;
					  4'h8: rcon=32'h80000000;
					  4'h9: rcon=32'h1b000000;
					  4'ha: rcon=32'h36000000;
					  default: rcon=32'h00000000;
				 endcase
			 end
			 
			 assign outKey[127:96]=w0^sub^rcon;
			 assign outKey[95:64]=w0^sub^rcon^w1;
			 assign outKey[63:32]=w0^sub^rcon^w1^w2;
			 assign outKey[31:0]=w0^sub^rcon^w1^w2^w3; 
			 assign validOut=1;
						 
			 
          
	
endmodule



module test();
   wire [127:0] key;
	wire keyLen;
	wire validIn; 
	wire   [3:0] rnum;
   wire validOut;
	wire [127:0] outKey;
	assign key=128'hD6AA74FDD2AF72FADAA678F1D6AB76FE;
	assign rnum=2;
	assign validIn=1;
	assign validOut=1;
	assign keyLen=1;
	wire[31:0] temp,sub;
	assign temp=32'hD6AB76FE;
	genvar itr;

			generate
					for (itr = 0 ; itr <= 31; itr = itr+8) begin :a
								sbox sb (.sbox_data_in(temp[itr +:8]) , .sbox_data_out(sub[itr +:8]));
								end
			endgenerate
		 
  
  KeySchedule aes (.key(key),.keyLen(keyLen),.validIn(validIn),.rnum(rnum),.validOut(validOut),.outKey(outKey));
endmodule


