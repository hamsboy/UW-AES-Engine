

module sbox
	#(
	parameter ROM_WIDTH = 20			// Width of memory element, i.e. M20k has 20 bit width
	)
	(
	input clk,
	input [7:0] sbox_data_in,	
	// 8-bit/1-byte input from state
	output reg [7:0] sbox_data_out	// 1-byte output, reg because it stores a value
	);
	
	// 20-bit data, 256 rows in data_ROM
	reg [ROM_WIDTH-1:0] rom [255:0];
	// Temporary 20 bit value from ROM because we onyl need the first 8 bits (mul1)
	initial
	begin
		$readmemh("C:\\Users\\youma\\Documents\\AES\\rom_20.txt", rom);
	end

	always @ (posedge clk)
	begin
		sbox_data_out <= rom[sbox_data_in][19:12];
	end

endmodule














// Simple Testbench
module sbox_testbench();
   wire [7:0] data;
	wire [7:0] out;
	reg clk;

	assign data = 8'h00;
	// Expected output = 25
	
	// Set up the clock
	parameter CLOCK_PERIOD = 100;	// simulating a toggling clock
	initial clk = 1;

	always begin
		#(CLOCK_PERIOD/2) clk = ~clk;				// clock toggle
	end

	sbox dut(.clk(clk),.sbox_data_in(data), .sbox_data_out(out));

endmodule

