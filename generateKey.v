

module generateKey
	#(
	parameter ROM_WIDTH = 20,
	parameter KEY_WIDTH = 128,				// Key width can be 128 or 256 bit
	parameter WORD = 32						// Defines length of a word as 32 bits
	) 
	(
	input [KEY_WIDTH-1:0] key,				// Input key to be generated
	input [KEY_WIDTH-1:0] prev_key,		// Key from previous round (for 256 bit key)
	input keyLen,								// If low key length is 128, if high key length is 256 bit
	input flip,									// For 256 bit key
	input validIn,								// Valid bit in. When high, data in is valid and should be processed
	input	[3:0] rnum,							// Round number in
	input clk,
	input reset,								// active low
	output reg validOut,						// Valid bit out. When high, data out is valid and can be used in another function	
	output reg [3:0] rnum_out,
	output reg outflip,						// For 256 bit key 
	output reg [KEY_WIDTH-1:0] outKey	// Final key which has been generated
	);

	
	

	
	
	// intermediete values
	reg [WORD-1:0] w0,w1,w2,w3,w4;
	wire [WORD-1:0] sub;
	reg [WORD-1:0] temp;
	reg [KEY_WIDTH-1:0] round_key;
	//split the key into 4 words


	always @(*) begin
		if (keyLen) begin  
			w0 <= prev_key[127:96];
			w1 <= prev_key[95:64];
			w2 <= prev_key[63:32];
			w3 <= prev_key[31:0];
			w4 <= key[31:0];
		end else begin
			w0 <= key[127:96];
			w1 <= key[95:64];
			w2 <= key[63:32];
			w3 <= key[31:0];
			w4 <= key[31:0];
		end
	end

	
//	reg [19:0] data_ROM [0:255];
//
//initial $readmemh("C:\\Users\\youma\\Documents\\AES\\rom_20.txt", data_ROM); 
// 
//genvar itr;
//generate
//		for (itr = 0 ; itr <= 31; itr = itr+8) begin :s
//      assign sub[itr +:8]=data_ROM[temp[itr +:8]][19:12];
//					end
// endgenerate
 
 

 
 genvar i;
 generate	
		for (i = 0 ; i <=31; i = i + 8) begin :lut		
			sbox sb (.clk(clk),
										.sbox_data_in(temp[i+:8]),
										.sbox_data_out(sub[i+:8])
										);
		end
	endgenerate
 
 
 

	always @(*) begin

		if (!flip) begin  
			temp <= w4;
			round_key[127:96] <= w0 ^ sub;
			round_key[95:64] 	<= w0 ^ sub ^ w1;
			round_key[63:32] 	<= w0 ^ sub ^ w1 ^ w2;
			round_key[31:0] 	<= w0 ^ sub ^ w1 ^ w2 ^ w3;

			//update rcon
			rnum_out <= rnum + 1;
		end else begin
			//rotate the last word by one byte(so rotate w3 by  1byte)
			temp <= {w4[23:0],w4[31:24]};

			round_key[127:96] <= w0 ^ sub ^ rcon(rnum);
			round_key[95:64]	<= w0 ^ sub ^ rcon(rnum) ^ w1;
			round_key[63:32]	<= w0 ^ sub ^ rcon(rnum) ^ w1 ^ w2;
			round_key[31:0]	<= w0 ^ sub ^ rcon(rnum) ^ w1 ^ w2 ^ w3;
			rnum_out<=rnum;
		end 

		if (!keyLen) begin
			outflip <= flip;
			rnum_out <= rnum + 1;
		end else begin
			outflip <= !flip;
		end 
	end

	always @(posedge clk,negedge reset) begin
		if(!reset) begin
			outKey <= 0;
			validOut <= 0;
		end else begin
			if(validIn) begin
				outKey = round_key;
			end
		validOut <= validIn;
		end
	end




	function [31:0] rcon;
		input	[3:0]	rc;
		
		case(rc)	
			4'h0: 	rcon = 32'h01_00_00_00;
			4'h1: 	rcon = 32'h02_00_00_00;
			4'h2: 	rcon = 32'h04_00_00_00;
			4'h3: 	rcon = 32'h08_00_00_00;
			4'h4: 	rcon = 32'h10_00_00_00;
			4'h5: 	rcon = 32'h20_00_00_00;
			4'h6: 	rcon = 32'h40_00_00_00;
			4'h7: 	rcon = 32'h80_00_00_00;
			4'h8: 	rcon = 32'h1b_00_00_00;
			4'h9: 	rcon = 32'h36_00_00_00;
			default: rcon = 32'h00_00_00_00;
		endcase
	endfunction

endmodule

module AEScore_test();
	wire [127:0] key,prev_key;
	 
	
	wire validIn; 
	//wire   [3:0] rnum;
	wire validOut;
	wire [127:0] outKey;
	wire [127:0] data; 
	wire [127:0] dataOut;
	
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
	//reg [127:0] testvectors [0:1];
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


	generateKey aes (.key(prev_key),.prev_key(prev_key),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r1),.rnum(4'h0),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k1),.flip(1'b1),.outflip(f2));
	generateKey aes2 (.key(k1),.prev_key(prev_key),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r2),.rnum(r1),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k2),.flip(f2),.outflip(f3));
	generateKey aes3 (.key(k2),.prev_key(k1),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r3),.rnum(r2),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k3),.flip(f3),.outflip(f4));
	generateKey aes4 (.key(k3),.prev_key(k2),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r4),.rnum(r3),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k4),.flip(f4),.outflip(f5));
	generateKey aes5 (.key(k4),.prev_key(k3),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r5),.rnum(r4),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k5),.flip(f5),.outflip(f6));
	generateKey aes6 (.key(k5),.prev_key(k4),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r6),.rnum(r5),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k6),.flip(f6),.outflip(f7));
	generateKey aes7 (.key(k6),.prev_key(k5),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r7),.rnum(r6),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k7),.flip(f7),.outflip(f8));
	generateKey aes8 (.key(k7),.prev_key(k6),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r8),.rnum(r7),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k8),.flip(f8),.outflip(f9));
	generateKey aes9 (.key(k8),.prev_key(k7),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r9),.rnum(r8),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k9),.flip(f9),.outflip(f10));
	generateKey aes10 (.key(k9),.prev_key(k8),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r10),.rnum(r9),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k10),.flip(f10),.outflip(f11));

	//generateKey aes11 (.key(k10),.prev_key(k9),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r11),.rnum(r10),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k11),.flip(f11),.outflip(f12));
	//generateKey aes12 (.key(k11),.prev_key(k10),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r12),.rnum(r11),.clk(clk),.reset(reset),.validOut(validOut),.outKey(k12),.flip(f12),.outflip(f13));
	//generateKey aes13 (.key(k12),.prev_key(k11),.keyLen(keyLen),.validIn(1'b1),.rnum_out(r13),.rnum(r12),.clk(clk),.reset(reset),.validOut(validOut),.outKey(outKey),.flip(f13),.outflip(f14));

endmodule