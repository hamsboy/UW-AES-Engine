/* Subyte and MixColumn*/
module MixColumn_SubByte(in_byte, out_byte);
	input [127:0] in_byte;
	output wire [127:0] out_byte;
	
  reg [15:0] data_ROM [0:255];
 
  initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
 
  //First Column
  assign out_byte[127:120] = ((data_ROM[in_byte[127:120]][15])?((data_ROM[in_byte[127:120]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[127:120]][15:8]<<1))^( data_ROM[in_byte[119:112]][7:0])^( data_ROM[in_byte[111:104]][15:8])^( data_ROM[in_byte[103:96] ][15:8]);
  assign out_byte[119:112] = (data_ROM[in_byte[127:120]][15:8])^( (data_ROM[in_byte[119:112]][15])?((data_ROM[in_byte[119:112]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[119:112]][15:8]<<1) )^( data_ROM[in_byte[111:104]][7:0])^( data_ROM[in_byte[103:96] ][15:8]);
  assign out_byte[111:104] = (data_ROM[in_byte[127:120]][15:8])^(data_ROM[in_byte[119:112] ][15:8])^((data_ROM[in_byte[111:104]][15])?((data_ROM[in_byte[111:104]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[111:104]][15:8]<<1))^( data_ROM[in_byte[103:96]][7:0]);
  assign out_byte[103:96]  = (data_ROM[in_byte[127:120]][7:0])^( data_ROM[in_byte[119:112]][15:8])^( data_ROM[in_byte[111:104]][15:8])^( (data_ROM[in_byte[103:96]][15])?((data_ROM[in_byte[103:96]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[103:96]][15:8]<<1));
	
	
	 //Second Column
  assign  out_byte[95:88]  = ((data_ROM[in_byte[95:88]][15])?((data_ROM[in_byte[95:88]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[95:88]][15:8]<<1))^( data_ROM[in_byte[87:80]][7:0])^( data_ROM[in_byte[79:72]][15:8])^( data_ROM[in_byte[71:64]][15:8]);
  assign out_byte[87:80]  = (data_ROM[in_byte[95:88]][15:8])^( (data_ROM[in_byte[87:80]][15])?((data_ROM[in_byte[87:80]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[87:80]][15:8]<<1) )^( data_ROM[in_byte[79:72]][7:0])^( data_ROM[in_byte[71:64]][15:8]);
  assign out_byte[79:72]  = (data_ROM[in_byte[95:88]][15:8])^(data_ROM[in_byte[87:80] ][15:8])^((data_ROM[in_byte[79:72]][15])?((data_ROM[in_byte[79:72]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[79:72]][15:8]<<1))^( data_ROM[in_byte[71:64]][7:0]);
  assign out_byte[71:64] = (data_ROM[in_byte[95:88]][7:0])^( data_ROM[in_byte[87:80]][15:8])^( data_ROM[in_byte[79:72]][15:8])^( (data_ROM[in_byte[71:64]][15])?((data_ROM[in_byte[71:64]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[71:64]][15:8]<<1));
	
	 //Third Column
  assign out_byte[63:56]  = ((data_ROM[in_byte[63:56]][15])?((data_ROM[in_byte[63:56]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[63:56]][15:8]<<1))^( data_ROM[in_byte[55:48]][7:0])^( data_ROM[in_byte[47:40]][15:8])^( data_ROM[in_byte[39:32]][15:8]);
  assign out_byte[55:48]   = (data_ROM[in_byte[63:56]][15:8])^( (data_ROM[in_byte[55:48]][15])?((data_ROM[in_byte[55:48]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[55:48]][15:8]<<1) )^( data_ROM[in_byte[47:40]][7:0])^( data_ROM[in_byte[39:32]][15:8]);
  assign out_byte[47:40]   = (data_ROM[in_byte[63:56]][15:8])^(data_ROM[in_byte[55:48]][15:8])^((data_ROM[in_byte[47:40]][15])?((data_ROM[in_byte[47:40]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[47:40]][15:8]<<1))^( data_ROM[in_byte[39:32]][7:0]);
  assign out_byte[39:32] = (data_ROM[in_byte[63:56]][7:0])^( data_ROM[in_byte[55:48]][15:8])^( data_ROM[in_byte[47:40]][15:8])^( (data_ROM[in_byte[39:32]][15])?((data_ROM[in_byte[39:32]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[39:32]][15:8]<<1));

  //Fourth Column
  assign  out_byte[31:24]  = ((data_ROM[in_byte[31:24]][15])?((data_ROM[in_byte[31:24]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[31:24]][15:8]<<1))^( data_ROM[in_byte[23:16]][7:0])^( data_ROM[in_byte[15:8]][15:8])^( data_ROM[in_byte[7:0]][15:8]);
  assign out_byte[23:16]   = (data_ROM[in_byte[31:24]][15:8])^( (data_ROM[in_byte[23:16]][15])?((data_ROM[in_byte[23:16]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[23:16]][15:8]<<1) )^( data_ROM[in_byte[15:8]][7:0])^( data_ROM[in_byte[7:0]][15:8]);
  assign out_byte[15:8]   = (data_ROM[in_byte[31:24]][15:8])^(data_ROM[in_byte[23:16]][15:8])^((data_ROM[in_byte[15:8]][15])?((data_ROM[in_byte[15:8]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[15:8]][15:8]<<1))^( data_ROM[in_byte[7:0]][7:0]);
  assign out_byte[7:0] = (data_ROM[in_byte[31:24]][7:0])^( data_ROM[in_byte[23:16]][15:8])^( data_ROM[in_byte[15:8]][15:8])^( (data_ROM[in_byte[7:0]][15])?((data_ROM[in_byte[7:0]][15:8]<<1) ^ 8'h1b):(data_ROM[in_byte[7:0]][15:8]<<1));
	
	
endmodule
