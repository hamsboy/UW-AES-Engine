

module subByte
	#(
	parameter DATA_WIDTH = 128,	// Size of data, 128 bits = 0x80 in hex
	parameter ROM_WIDTH = 20,		// Width of memory element, i.e. M20k has 20 bit width
	parameter SELECT_SUBBYTE =1// When high, subByte will be done using looking table
											// When low, subByte will be done using combinational logic
	)
	(
	input clk,
	//input rst,													// active low
   input subByte_valid_in,									// Valid bit. When high, data is valid and should be processed
	input wire [DATA_WIDTH-1:0] subByte_data_in, 	// subByte block data to be processed
	output reg [DATA_WIDTH-1:0] subByte_data_out,  	// Block data which has gone through subByte function
	output reg subByte_valid_out 								// Valid bit. When high, data is valid and can be used in another function.	
	); 															// end signals
	


//reg [19:0] data_ROM [0:255];
//
//initial $readmemh("C:\\Users\\youma\\Documents\\AES\\rom_20.txt", data_ROM); 
//
//genvar itr;
//generate
//		for (itr = 0 ; itr <= 127; itr = itr+8) begin :s
//      assign subByte_data_out[itr +:8]=data_ROM[subByte_data_in[itr +:8]][19:12];
//					end
// endgenerate




// local parameter to define number of bytes
	// bytes = 128 / 8 = 16 implemented using LSR
	localparam NUM_BYTES = DATA_WIDTH >> 3;
	
	// Intermediete values to store state
	wire [DATA_WIDTH-1:0] lut_temp, comb_temp;
	
	genvar i, j;
	
	// create sbox using LUT
	generate	
		for (i = 0 ; i < NUM_BYTES; i = i + 1) begin :lut		
			sbox #(ROM_WIDTH) sb (.clk(clk),
										.sbox_data_in(subByte_data_in[(i*8)+7:(i*8)]),
										.sbox_data_out(lut_temp[(i*8)+7:(i*8)])
										);
		end
	endgenerate
	
	// create sbox using logic
	generate 
		for(j = 0; j < NUM_BYTES; j = j + 1) begin :comb
			subByteCombinational sbc 	(
												.data_in(subByte_data_in[(j*8)+7:(j*8)]),
												.data_out(comb_temp[(j*8)+7:(j*8)])
												);
		end
	endgenerate
	
	// Now determine what output value will be based on SELECT_SUBBYTE
	// Update registers
	//always @(posedge clk or negedge rst) begin
	always @(*) begin
		//if (!rst) begin
		//	subByte_valid_out <= 1'b0;
		//end else begin // if (rst)
			if (subByte_valid_in) begin
				if (SELECT_SUBBYTE) begin
					subByte_data_out <= lut_temp;
				end else begin
					subByte_data_out <= comb_temp;
				end // end SELECT_SUBBYTE check
			end // end valid check
			subByte_valid_out <= subByte_valid_in;
		//end //end rst check
	end // end always block
	
endmodule



