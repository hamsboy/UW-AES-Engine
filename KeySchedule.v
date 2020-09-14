/* Hamidou Diallo 
7/15/2020
This program expends a single key (128-bits)
*/

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
								sbox sb (.sbox_data_in(temp[itr +:8]),.clk(clk),.reset(reset) , .sbox_data_out(sub[itr +:8]));
								end
			endgenerate
		 
		  
	       
       
			 
				always @(posedge clk,negedge reset) begin
					if(!reset) begin
						outKey<=0;
						validOut<=0;
					 end else begin
							  if(validIn) begin
									if (!flip) begin  
										 temp<=w4;
										 outKey[127:96]<=w0^sub;
										 outKey[95:64]<=w0^sub^w1;
										 outKey[63:32]<=w0^sub^w1^w2;
										 outKey[31:0]<=w0^sub^w1^w2^w3;
											
										 //update rcon
										 rnum_out<=rnum+1;
									
									end else begin
										  //rotate the last word by one byte(so rotate w3 by  1byte)
										  temp<={w4[23:0],w4[31:24]};
										  
										  outKey[127:96]<=w0^sub^rcon(rnum);
										  outKey[95:64]<=w0^sub^rcon(rnum)^w1;
										  outKey[63:32]<=w0^sub^rcon(rnum)^w1^w2;
										  outKey[31:0]<=w0^sub^rcon(rnum)^w1^w2^w3;
										  rnum_out<=rnum;
									end 
								  
									if (!keyLen)begin
											outflip<=flip;
											rnum_out<=rnum+1;
								  end else begin
											outflip<=!flip;
								  end 
								 validOut<=validIn;
							 end
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

//=================================================================================================================================================================
module test();
        wire [127:0] key,prev_key;
	 
	
	wire validIn; 
	//wire   [3:0] rnum;
        wire validOut;
	wire [127:0] outKey;
	wire[127:0] data; 
	wire[127:0] dataOut;
	
	assign data=128'h00112233445566778899aabbccddeeff;
assign prev_key=128'h000102030405060708090a0b0c0d0e0f;
//assign key=128'h101112131415161718191a1b1c1d1e1f;

	assign rnum=1;
	
	assign validIn=0;
	assign validOut=1;
	assign keyLen=0;	



//
//   reg [127:0] s_in;
//	wire [127:0] s_out;
	reg clk;	
	reg reset;
	// 128-bit data
	// 11 rows in shifrRowTest.tv file
	reg [127:0] testvectors [0:1];
	//integer i;

	
	// Set up the clock
	parameter CLOCK_PERIOD = 100;	// simulating a toggling clock
	initial clk = 1;

	always begin
		#(CLOCK_PERIOD/2) clk = ~clk;				// clock toggle
	end
	initial begin
	reset=0;
	#100;
	reset=1;
	end
	
wire [127:0] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12;
wire f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14;
wire [3:0] r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;


KeyExpansion aes (.key(prev_key),.prev_key(prev_key),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r1),.rnum(4'h0),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k1),.flip(1'b1),.outflip(f2));
KeyExpansion aes2 (.key(k1),.prev_key(prev_key),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r2),.rnum(r1),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k2),.flip(f2),.outflip(f3));
KeyExpansion aes3 (.key(k2),.prev_key(k1),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r3),.rnum(r2),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k3),.flip(f3),.outflip(f4));
KeyExpansion aes4 (.key(k3),.prev_key(k2),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r4),.rnum(r3),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k4),.flip(f4),.outflip(f5));
KeyExpansion aes5 (.key(k4),.prev_key(k3),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r5),.rnum(r4),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k5),.flip(f5),.outflip(f6));
KeyExpansion aes6 (.key(k5),.prev_key(k4),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r6),.rnum(r5),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k6),.flip(f6),.outflip(f7));
KeyExpansion aes7 (.key(k6),.prev_key(k5),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r7),.rnum(r6),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k7),.flip(f7),.outflip(f8));
KeyExpansion aes8 (.key(k7),.prev_key(k6),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r8),.rnum(r7),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k8),.flip(f8),.outflip(f9));
KeyExpansion aes9 (.key(k8),.prev_key(k7),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r9),.rnum(r8),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k9),.flip(f9),.outflip(f10));
KeyExpansion aes10 (.key(k9),.prev_key(k8),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r10),.rnum(r9),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k10),.flip(f10),.outflip(f11));

//KeyExpansion aes11 (.key(k10),.prev_key(k9),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r11),.rnum(r10),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k11),.flip(f11),.outflip(f12));
//KeyExpansion aes12 (.key(k11),.prev_key(k10),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r12),.rnum(r11),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k12),.flip(f12),.outflip(f13));
//KeyExpansion aes13 (.key(k12),.prev_key(k11),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r13),.rnum(r12),.clk(clk),.reset(reset),.validOut(validOut),.outKey(outKey),.flip(f13),.outflip(f14));









//KeyExpansion aes (.key(key),.keyLen(1'b1),.validIn(1'b1),.rnum(32'h01000000),.clk(clk),.reset(reset),.validOut(validOut),.outKey(outKey));
//KeyExpansion aes (.key(key),.keyLen(1'b1),.validIn(1'b1),.rnum(32'h01000000),.clk(clk),.reset(reset),.validOut(validOut),.outKey(outKey));
 
	// reference the device under test (shiftRow module)
	//shiftRow dut (.shiftRow_data_in(s_in), .shiftRow_data_out(s_out));
//	
//	initial begin	// embed the test vector
//		$readmemh("shiftRowTest.tv", testvectors); // read in test vectors from .tv file
//		s_in = testvectors[0];
//		end	
//
//	
	//wire [7:0] address;
	
	//reg [15:0] data_ROM [0:255];
  //wire [255:0 ] adress;
  //initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
  
	//assign address=(data_ROM[8'hff][15])?((data_ROM[8'hff][15:8]<<1) ^ 8'h1b):(data_ROM[8'hff][15:8]<<1); 
 // AESCORE1 core1 (.key(key), .clk(clk),.keyLen(keyLen),.validIn(validIn), .validOut(validOut), .data(data), .dataOut(dataOut),.keyOut(outKey));
endmodule


