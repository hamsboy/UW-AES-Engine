//==================================================================================================================
module MixColumn(in_byte, out_byte);
	input [127:0] in_byte;
	output wire [127:0] out_byte;
	
  reg [19:0] data_ROM [0:255];
  wire [319:0 ] adress;
  initial $readmemh("C:\\Users\\youma\\Desktop\\Capstone\\verilog\\rom.txt", data_ROM); 
  assign adress[0 +:20]=data_ROM[in_byte[127:120]];
  assign adress[20 +:20]=data_ROM[in_byte[119:112]];
  assign adress[40 +:20]=data_ROM[in_byte[111:104]];
  assign adress[60 +:20]=data_ROM[in_byte[103:96]];
  
     
  assign out_byte[127:120] = ({adress[18:16],adress[11:10],adress[13],adress[9:8]})^(adress[20 +:8])^(adress[52 +:8])^(adress[72 +:8]);
  assign out_byte[119:112] = (adress[12 +:8])^({adress[20+18:20+16],adress[20+11:20+10],adress[20+13],adress[20+9:20+8]})^(adress[40 +:8])^(adress[72 +:8]);
  assign out_byte[111:104] = (adress[12 +:8])^(adress[32 +:8])^({adress[40+18:40+16],adress[40+11:40+10],adress[40+13],adress[40+9:40+8]})^(adress[60+:8]);
  assign out_byte[103:96]  = (adress[0 +:8])^(adress[32+:8])^(adress[52 +:8])^({adress[60+18:60+16],adress[60+11:60+10],adress[60+13],adress[60+9:60+8]});
	
	

	  
  assign adress[80 +:20]= data_ROM[in_byte[95:88]];
  assign adress[100 +:20]=data_ROM[in_byte[87:80]];
  assign adress[120 +:20]=data_ROM[in_byte[79:72]];
  assign adress[140 +:20]=data_ROM[in_byte[71:64]];
  
  
  assign out_byte[95:88] = ({adress[80+18:80+16],adress[80+11:80+10],adress[80+13],adress[80+9:80+8]})^(adress[100 +:8])^(adress[120+12 +:8])^(adress[140+12 +:8]);
  assign out_byte[87:80] = (adress[80+12 +:8])^({adress[100+18:100+16],adress[100+11:100+10],adress[100+13],adress[100+9:100+8]})^(adress[120 +:8])^(adress[140+12 +:8]);
  assign out_byte[79:72] = (adress[80+12 +:8])^(adress[100+12 +:8])^({adress[120+18:120+16],adress[120+11:120+10],adress[120+13],adress[120+9:120+8]})^(adress[140 +:8]);
  assign out_byte[71:64]  = (adress[80 +:8])^(adress[100+12 +:8])^(adress[120+12 +:8])^({adress[140+18:140+16],adress[140+11:140+10],adress[140+13],adress[140+9:140+8]});
  

	
	
  assign adress[160 +:20]= data_ROM[in_byte[63:56]];
  assign adress[180 +:20]=data_ROM[in_byte[55:48]];
  assign adress[200 +:20]=data_ROM[in_byte[47:40]];
  assign adress[220 +:20]=data_ROM[in_byte[39:32]];
  
   
  assign out_byte[63:56] = ({adress[160+18:160+16],adress[160+11:160+10],adress[160+13],adress[160+9:160+8]})^(adress[180 +:8])^(adress[200+12 +:8])^(adress[220+12 +:8]);
  assign out_byte[55:48] = (adress[160+12 +:8])^({adress[180+18:180+16],adress[180+11:180+10],adress[180+13],adress[180+9:180+8]})^(adress[200 +:8])^(adress[220+12 +:8]);
  assign out_byte[47:40] = (adress[160+12 +:8])^(adress[180+12 +:8])^({adress[200+18:200+16],adress[200+11:200+10],adress[200+13],adress[200+9:200+8]})^(adress[220 +:8]);
  assign out_byte[39:32]  = (adress[160 +:8])^(adress[180+12 +:8])^(adress[200+12 +:8])^({adress[220+18:220+16],adress[220+11:220+10],adress[220+13],adress[220+9:220+8]});
	

   assign adress[240 +:20]= data_ROM[in_byte[31:24]];
   assign adress[260 +:20]=data_ROM[in_byte[23:16]];
   assign adress[280 +:20]=data_ROM[in_byte[15:8]];
   assign adress[300 +:20]=data_ROM[in_byte[7:0]];
	
	 
  assign out_byte[31:24] = ({adress[240+18:240+16],adress[240+11:240+10],adress[240+13],adress[240+9:240+8]})^(adress[260 +:8])^(adress[280+12 +:8])^(adress[300+12 +:8]);
  assign out_byte[23:16] = (adress[240+12 +:8])^({adress[260+18:260+16],adress[260+11:260+10],adress[260+13],adress[260+9:260+8]})^(adress[280 +:8])^(adress[300+12 +:8]);
  assign out_byte[15:8]  = (adress[240+12 +:8])^(adress[260+12 +:8])^({adress[280+18:280+16],adress[280+11:280+10],adress[280+13],adress[280+9:280+8]})^(adress[300 +:8]);
  assign out_byte[7:0]  = (adress[240 +:8])^(adress[260+12 +:8])^(adress[280+12 +:8])^({adress[300+18:300+16],adress[300+11:300+10],adress[300+13],adress[300+9:300+8]});
endmodule

//==================================================================================================================
