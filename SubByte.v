module subByte
	(
	input wire [127:0] state,
	input  clk,
	input  subbyte_valid_in,	// Valid bit. When high, data is valid and should be processed.
	output wire  [127:0]state_out,
	output subbyte_valid_out 
	);
       



genvar itr;
generate
		for (itr = 0 ; itr <= 127; itr = itr+8) begin :s
					sbox sb (.sbox_data_in(state[itr +:8]) , .sbox_data_out(state_out[itr +:8]));
				   end
endgenerate


endmodule

