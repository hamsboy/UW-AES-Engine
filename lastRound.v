module lastRound
	#(
	parameter DATA_WIDTH = 128				// size of data, always 128 bit
	)
	(
	
   input keyLen	,// Active low
	input wire [DATA_WIDTH-1:0] prev_key, 
	input round_valid_in, 						// Valid bit in. When high, data is valid and should be processed
	input wire [DATA_WIDTH-1:0] state_in, 	// Plaintext block data to be ecrypted
	input wire [DATA_WIDTH-1:0] key_in,		// Key used to encrypt plaintext data
	output reg [DATA_WIDTH-1:0] state_out,// Block data which has gone through a single round of encryption
	output wire round_valid_out 				// Valid bit out. When high, data is valid and can be used in another function.	
	);													// end signals

	
	wire [DATA_WIDTH-1:0] state1; 	// connect the data from first layer to second  
	wire [DATA_WIDTH-1:0] state2;		// connect data from second layer to third
	
	
	wire round_valid1;	// connect valid bit from first layer to second
	
	
	shiftRow #(DATA_WIDTH) sr	(
										.shiftRow_valid_in(round_valid_in),
										.shiftRow_data_in(state_in),
										.shiftRow_data_out(state1),
										.shiftRow_valid_out(round_valid1)
										);
										
									
	
	subByte #(DATA_WIDTH) sub 	(     .subByte_valid_in(round_valid1),
																			.subByte_data_in(state1),
																			.subByte_data_out(state2),
																			.subByte_valid_out(round_valid_out)
																			);
											
																			
always @(*) begin
	  if(keyLen) begin
	    state_out<=prev_key^state2;
	  end else begin
	     state_out<=key_in^state2;
	  end
end

//assign state_out=temp_key^state2;
	
endmodule


