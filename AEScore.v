module AEScore
	#(
	parameter KEY_WIDTH = 128,						// size of key, either 128 or 256 bit
	parameter DATA_WIDTH = 128,					// size of data, always 128 bit
	parameter WORD = 32								// Defines length of a word as 32 bits
	)
	(
	input clk,
	input rst, 											// active low
	input valid_in,									// Valid bit in. When high, data is valid and should be processed
	input [DATA_WIDTH-1:0] plaintext_in,		// data to be encrypted
	input [KEY_WIDTH-1:0] key_in, 				// key to be used for encryption
	input keyLen,
	output [DATA_WIDTH-1:0] ciphertext_out,	// ciphertext out
	output [DATA_WIDTH-1:0] key_out,
	output valid_out									// Valid bit out. When high, data is valid and can be used in another function.	
	); 													// end signals/

	
	localparam NUM_ROUNDS = (KEY_WIDTH == 128) ? 10 : 14;
	 
	// intermediete logic
	wire valid [NUM_ROUNDS+1:0];
	wire validRound [NUM_ROUNDS+1:0];
	wire [127:0] keys [NUM_ROUNDS+1:0] ;
	wire [127:0] state [NUM_ROUNDS+1:0];
	wire [3:0] rnum [NUM_ROUNDS+1:0];						// Round number
	wire flips [NUM_ROUNDS+1:0];
	
	// XOR with the key to establish the state ("Round 0")
	assign keys[0]=key_in[KEY_WIDTH-1:KEY_WIDTH-128];
	assign keys[1]=key_in[127:0];
	assign state[1] = plaintext_in ^ keys[0];



assign valid[1]=valid_in;
assign rnum[1]=4'b0;
assign flips[1]=1'b1;
assign validRound[1]=valid_in;
	
	genvar i;
	generate
		for (i = 1; i < NUM_ROUNDS; i = i + 1) begin :round    								
			generateKey aes (	.key(keys[i]),
									.prev_key(keys[i-1]),
									.keyLen(keyLen),
									.validIn(valid[i]),
									.rnum(rnum[i]),
									.rnum_out(rnum[i+1]),
									.clk(clk),
									.reset(rst),
									.validOut(valid[i+1]),
									.outKey(keys[i+1]),
									.flip(flips[i]),
									.outflip(flips[i+1])
									);
									
			encryptSingleRound #( DATA_WIDTH) round 	(.keyLen(keyLen),
			                                                               .prev_key(keys[i]),
																								.clk(clk),
																								.rst(rst),
																								.round_valid_in(validRound[i]),
																								.state_in(state[i]),
																								.key_in(keys[i+1]),
																								.state_out(state[i+1]),
																								.round_valid_out(validRound[i+1])
																								);
	
		end
	endgenerate
	
	
	//=================================================================================================
	// Final round:
	


	generateKey aes (	
							.key(keys[NUM_ROUNDS]),
							.prev_key(keys[NUM_ROUNDS-1]),
							.keyLen(keyLen),
							.validIn(valid[NUM_ROUNDS]),
							.rnum(rnum[NUM_ROUNDS]),
							.rnum_out(rnum[NUM_ROUNDS+1]),
							.clk(clk),
							.reset(rst),
							.validOut(valid[NUM_ROUNDS+1]),
							.outKey(keys[NUM_ROUNDS+1]),
							.flip(flips[NUM_ROUNDS]),
							.outflip(flips[NUM_ROUNDS+1])
							);
							
	lastRound #(DATA_WIDTH) lastround 	(.keyLen(keyLen),
	                                                            .prev_key(keys[NUM_ROUNDS]),
																					.round_valid_in(validRound[NUM_ROUNDS]),
																					.state_in(state[NUM_ROUNDS]),
																					.key_in(keys[NUM_ROUNDS+1]), 
																					.state_out(state[NUM_ROUNDS+1]),
																					.round_valid_out(validRound[NUM_ROUNDS+1])
																				);
//	// Final Assignments
	assign key_out = keys[NUM_ROUNDS+1];
	assign ciphertext_out = state[NUM_ROUNDS+1];


	

	
endmodule 

module test();
//	assign data=128'h00112233445566778899aabbccddeeff;
//	assign prev_key=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
	
	//assign key=128'h101112131415161718191a1b1c1d1e1f;

	assign rnum=1;
	
	//assign validIn=0;
	
	assign keyLen=0;	



//
// reg [127:0] s_in;
//	wire [127:0] s_out;
	reg clk;	
	reg reset;
	// 128-bit data
	// 11 rows in shifrRowTest.tv file
//	reg [127:0] testvectors [0:1];
	wire [127:0] outKey;
	wire [127:0] dataOut;
	//integer i;

	
	// Set up the clock
	parameter CLOCK_PERIOD = 100;	// simulating a toggling clock
	initial clk = 1;

	always begin
		#(CLOCK_PERIOD/2) clk = ~clk;				// clock toggle
	end
	
	initial begin
		reset = 0;
		#50;
		reset = 1;
	end

	
	// device under test
	AEScore dut (.key_in(128'h000102030405060708090a0b0c0d0e0f),
						.clk(clk),
						
						.keyLen(keyLen),
						.valid_in(1'b1),
                  .rst(reset),
						.valid_out(validOut),
						.plaintext_in(128'h00112233445566778899aabbccddeeff),
						.ciphertext_out(dataOut),
						.key_out(outKey));
endmodule

