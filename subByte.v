

module subByte
	#(
	parameter DATA_WIDTH = 128	// Size of data, 128 bits = 0x80 in hex
	)
	(
	//input clk,
	//input rst,													// active low
	input subByte_valid_in,									// Valid bit. When high, data is valid and should be processed
	input wire [DATA_WIDTH-1:0] subByte_data_in, 	// subByte block data to be processed
	output wire [DATA_WIDTH-1:0] subByte_data_out,  	// Block data which has gone through subByte function
	output reg subByte_valid_out 							// Valid bit. When high, data is valid and can be used in another function.	
	); 															// end signals
	


reg [19:0] data_ROM [0:255];

initial $readmemh("C:\\Users\\youma\\Documents\\AES\\rom_20.txt", data_ROM); 

genvar itr;
generate
		for (itr = 0 ; itr <= 127; itr = itr+8) begin :s
      assign subByte_data_out[itr +:8]=data_ROM[subByte_data_in[itr +:8]][19:12];
					end
 endgenerate
endmodule
