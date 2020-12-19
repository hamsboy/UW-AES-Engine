module subByte_mixColumn
	#(	
	parameter DATA_WIDTH = 128				// Size of data		
	)
	(
	input clk,
	input rst,										// active low
	input sb_mc_valid_in,						// Valid bit in. When high, data is valid and should be processed
	input [DATA_WIDTH-1:0] state_in,			// 128 bit state input to undergo combined SubByte and MixColumn function using LUT
	output reg [DATA_WIDTH-1:0] stateOut,	// 128 bit state output which has gone through SubByte and MixColumn
	output reg sb_mc_valid_out					// Valid bit out. When high, data is valid and can be used in another function
	);
	
	// 20-bit data, 256 rows in data_ROM 
	reg [19:0] data_ROM [0:255]; 

   reg [DATA_WIDTH-1:0] state_out;
	initial $readmemh("C:\\Users\\youma\\Documents\\AES\\rom_20.txt", data_ROM); 
	
	always @(*) begin

          state_out[127:120] <= ( {data_ROM[state_in[127:120]][18:16],data_ROM[state_in[127:120]][11:10],data_ROM[state_in[127:120]][13],data_ROM[state_in[127:120]][9:8]})^(data_ROM[state_in[119:112]][7:0])^(data_ROM[state_in[111:104]][19:12])^(data_ROM[state_in[103:96]][19:12]);
          state_out[119:112] <= ( data_ROM[state_in[127:120]][19:12])^({data_ROM[state_in[119:112]][18:16],data_ROM[state_in[119:112]][11:10],data_ROM[state_in[119:112]][13],data_ROM[state_in[119:112]][9:8]})^(data_ROM[state_in[111:104]][7:0])^(data_ROM[state_in[103:96]][19:12]);
	       state_out[111:104] <= (data_ROM[state_in[127:120]][19:12])^(data_ROM[state_in[119:112]][19:12])^({data_ROM[state_in[111:104]][18:16],data_ROM[state_in[111:104]][11:10],data_ROM[state_in[111:104]][13],data_ROM[state_in[111:104]][9:8]})^(data_ROM[state_in[103:96]][7:0]);
          state_out[103:96]  <= (data_ROM[state_in[127:120]][7:0])^(data_ROM[state_in[119:112]][19:12])^(data_ROM[state_in[111:104]][19:12])^({data_ROM[state_in[103:96]][18:16],data_ROM[state_in[103:96]][11:10],data_ROM[state_in[103:96]][13],data_ROM[state_in[103:96]][9:8]});
	


			 state_out[95:88] <= ( {data_ROM[state_in[95:88]][18:16],data_ROM[state_in[95:88]][11:10],data_ROM[state_in[95:88]][13],data_ROM[state_in[95:88]][9:8]})^(data_ROM[state_in[87:80]][7:0])^(data_ROM[state_in[79:72]][19:12])^(data_ROM[state_in[71:64]][19:12]);
          state_out[87:80] <= ( data_ROM[state_in[95:88]][19:12])^({data_ROM[state_in[87:80]][18:16],data_ROM[state_in[87:80]][11:10],data_ROM[state_in[87:80]][13],data_ROM[state_in[87:80]][9:8]})^(data_ROM[state_in[79:72]][7:0])^(data_ROM[state_in[71:64]][19:12]);
	       state_out[79:72]<= (data_ROM[state_in[95:88]][19:12])^(data_ROM[state_in[87:80]][19:12])^({data_ROM[state_in[79:72]][18:16],data_ROM[state_in[79:72]][11:10],data_ROM[state_in[79:72]][13],data_ROM[state_in[79:72]][9:8]})^(data_ROM[state_in[71:64]][7:0]);
          state_out[71:64]  <= (data_ROM[state_in[95:88]][7:0])^(data_ROM[state_in[87:80]][19:12])^(data_ROM[state_in[79:72]][19:12])^({data_ROM[state_in[71:64]][18:16],data_ROM[state_in[71:64]][11:10],data_ROM[state_in[71:64]][13],data_ROM[state_in[71:64]][9:8]});
	


			 state_out[63:56] <= ( {data_ROM[state_in[63:56]][18:16],data_ROM[state_in[63:56]][11:10],data_ROM[state_in[63:56]][13],data_ROM[state_in[63:56]][9:8]})^(data_ROM[state_in[55:48]][7:0])^(data_ROM[state_in[47:40]][19:12])^(data_ROM[state_in[39:32]][19:12]);
          state_out[55:48] <= ( data_ROM[state_in[63:56]][19:12])^({data_ROM[state_in[55:48]][18:16],data_ROM[state_in[55:48]][11:10],data_ROM[state_in[55:48]][13],data_ROM[state_in[55:48]][9:8]})^(data_ROM[state_in[47:40]][7:0])^(data_ROM[state_in[39:32]][19:12]);
	       state_out[47:40] <= (data_ROM[state_in[63:56]][19:12])^(data_ROM[state_in[55:48]][19:12])^({data_ROM[state_in[47:40]][18:16],data_ROM[state_in[47:40]][11:10],data_ROM[state_in[47:40]][13],data_ROM[state_in[47:40]][9:8]})^(data_ROM[state_in[39:32]][7:0]);
          state_out[39:32] <= (data_ROM[state_in[63:56]][7:0])^(data_ROM[state_in[55:48]][19:12])^(data_ROM[state_in[47:40]][19:12])^({data_ROM[state_in[39:32]][18:16],data_ROM[state_in[39:32]][11:10],data_ROM[state_in[39:32]][13],data_ROM[state_in[39:32]][9:8]});
	

			 state_out[31:24] <= ( {data_ROM[state_in[31:24]][18:16],data_ROM[state_in[31:24]][11:10],data_ROM[state_in[31:24]][13],data_ROM[state_in[31:24]][9:8]})^(data_ROM[state_in[23:16]][7:0])^(data_ROM[state_in[15:8]][19:12])^(data_ROM[state_in[7:0]][19:12]);
          state_out[23:16] <= ( data_ROM[state_in[31:24]][19:12])^({data_ROM[state_in[23:16]][18:16],data_ROM[state_in[23:16]][11:10],data_ROM[state_in[23:16]][13],data_ROM[state_in[23:16]][9:8]})^(data_ROM[state_in[15:8]][7:0])^(data_ROM[state_in[7:0]][19:12]);
	       state_out[15:8] <= (data_ROM[state_in[31:24]][19:12])^(data_ROM[state_in[23:16]][19:12])^({data_ROM[state_in[15:8]][18:16],data_ROM[state_in[15:8]][11:10],data_ROM[state_in[15:8]][13],data_ROM[state_in[15:8]][9:8]})^(data_ROM[state_in[7:0]][7:0]);
          state_out[7:0]  <= (data_ROM[state_in[31:24]][7:0])^(data_ROM[state_in[23:16]][19:12])^(data_ROM[state_in[15:8]][19:12])^({data_ROM[state_in[7:0]][18:16],data_ROM[state_in[7:0]][11:10],data_ROM[state_in[7:0]][13],data_ROM[state_in[7:0]][9:8]});
	end	


	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			sb_mc_valid_out <= 1'b0;
			stateOut<=128'b0;
		end else begin 
			//if (sb_mc_valid_in) begin
		    stateOut<=state_out;
			//end
			 sb_mc_valid_out=sb_mc_valid_in;
		end	
	end
endmodule



//
module subByte_mixColumn_testbench();

	
	//wire   [3:0] rnum;
     
	wire [127:0] state_out;
	wire[127:0] state_in; 
	
	
	
   assign state_in=128'h4915598f55e5d7a0daca94fa1f0a63f7;
//
//   reg [127:0] s_in;
//	wire [127:0] s_out;
	reg clk;	
	reg reset;
	// 128-bit data
	// 11 rows in shifrRowTest.tv file
	//reg [127:0] testvectors [0:1];
	//integer i;
   wire validout;
	wire validout2;
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
	
		
	
	wire [127:0] s_out;
	mix dut ( 
						.shiftRow_valid_in(1'b1), // send a constant high valid bit
						.shiftRow_data_in(state_in),
						.shiftRow_data_out(s_out),
						.shiftRow_valid_out(validOut2)
						);
	
	subByte_mixColumn sb (.clk(clk),.rst(reset),.sb_mc_valid_in(1'b1),.state_in(s_out),.stateOut(state_out),.sb_mc_valid_out(validout));
	
endmodule
