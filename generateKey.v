

module generateKey
	#(
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
	wire [WORD-1:0] sub;
	reg [WORD-1:0] temp;
	reg [KEY_WIDTH-1:0] round_key;
	//split the key into 4 words


	
	
reg [19:0] data_ROM [0:255];

initial $readmemh("C:\\Users\\youma\\Documents\\AES\\rom_20.txt", da ta_ROM); 

genvar itr;
generate
		for (itr = 0 ; itr <= 31; itr = itr+8) begin :s
      assign sub[itr +:8]=data_ROM[temp[itr +:8]][19:12];
					end
 endgenerate
	
	
	always @(*) begin

		if (!flip) begin 
				temp <= key[31:0];	
				if(keyLen) begin
					
					round_key[127:96] <= prev_key[127:96] ^ sub;
					round_key[95:64] 	<= prev_key[127:96] ^ sub ^ prev_key[95:64];
					round_key[63:32] 	<= prev_key[127:96]^ sub ^ prev_key[95:64] ^ prev_key[63:32];
					round_key[31:0] 	<= prev_key[127:96]^ sub ^ prev_key[95:64] ^ prev_key[63:32] ^prev_key[31:0];
				end else begin
				 
					round_key[127:96] <= key[127:96] ^ sub;
					round_key[95:64] 	<= key[127:96]^ sub ^ key[95:64];
					round_key[63:32] 	<= key[127:96]^ sub ^key[95:64]^ key[63:32];
					round_key[31:0] 	<= key[127:96]^ sub ^ key[95:64]^ key[63:32] ^ key[31:0];
				end
				//update rcon
				rnum_out <= rnum + 1;
		end else begin
				//rotate the last word by one byte(so rotate w3 by  1byte)
				 temp <= {key[23:0],key[31:24]};
				if(keyLen) begin
				

					round_key[127:96] <= prev_key[127:96] ^ sub ^ rcon(rnum);
					round_key[95:64]	<= prev_key[127:96]^ sub ^ rcon(rnum) ^ prev_key[95:64];
					round_key[63:32]	<= prev_key[127:96]^ sub ^ rcon(rnum) ^ prev_key[95:64] ^ prev_key[63:32];
					round_key[31:0]	<= prev_key[127:96] ^ sub ^ rcon(rnum) ^ prev_key[95:64] ^ prev_key[63:32]^ prev_key[31:0];
				end else begin 
				

					round_key[127:96] <= key[127:96]^ sub ^ rcon(rnum);
					round_key[95:64]	<= key[127:96] ^ sub ^ rcon(rnum) ^ key[95:64];
					round_key[63:32]	<= key[127:96]^ sub ^ rcon(rnum) ^ key[95:64] ^ key[63:32];
					round_key[31:0]	<= key[127:96] ^ sub ^ rcon(rnum) ^ key[95:64] ^key[63:32]^ key[31:0];
				end
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

