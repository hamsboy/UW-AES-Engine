

module shiftRow
	#(
	parameter DATA_WIDTH = 128								// Size of data, 128 bits constant
	)
	(
	input shiftRow_valid_in, 								// Valid bit. When high, data is valid and should be processed.
	input wire [DATA_WIDTH-1:0] shiftRow_data_in, 	// ShiftRow block data to be processed.
	output reg [DATA_WIDTH-1:0] shiftRow_data_out,  // Block data which has gone through shiftRow function
	output reg shiftRow_valid_out 						// Valid bit. When high, data is valid and can be used in another function.	
	);
	
	always @(*) begin
		if (shiftRow_valid_in) begin
			shiftRow_data_out[127:120] <= shiftRow_data_in[127:120];  
			shiftRow_data_out[119:112] <= shiftRow_data_in[87:80];
			shiftRow_data_out[111:104] <= shiftRow_data_in[47:40];
			shiftRow_data_out[103:96]  <= shiftRow_data_in[7:0];
				
			shiftRow_data_out[95:88]	<= shiftRow_data_in[95:88];
			shiftRow_data_out[87:80] 	<= shiftRow_data_in[55:48];
			shiftRow_data_out[79:72] 	<= shiftRow_data_in[15:8];
			shiftRow_data_out[71:64] 	<= shiftRow_data_in[103:96];
				
			shiftRow_data_out[63:56] 	<= shiftRow_data_in[63:56];
			shiftRow_data_out[55:48] 	<= shiftRow_data_in[23:16];
			shiftRow_data_out[47:40] 	<= shiftRow_data_in[111:104];
			shiftRow_data_out[39:32] 	<= shiftRow_data_in[71:64];
			
			shiftRow_data_out[31:24] 	<= shiftRow_data_in[31:24];
			shiftRow_data_out[23:16] 	<= shiftRow_data_in[119:112];
			shiftRow_data_out[15:8]  	<= shiftRow_data_in[79:72];
			shiftRow_data_out[7:0]   	<= shiftRow_data_in[39:32];
		end
			
		shiftRow_valid_out = shiftRow_valid_in;
			
	end
endmodule



