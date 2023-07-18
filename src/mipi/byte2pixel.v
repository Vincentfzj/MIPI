module byte2pixel(
	input 		clk		,
	input		resetn	,
	//RAW data
	input		raw_vld	,
	input	[15:0]	raw_data	,
	input			raw_vsync	,
	//pixel data
	output	reg 	pixel_vld	,
	output	reg	[39:0]	pixel_data //p1 p2 p3 p4
);


//=================================
reg 	frame_valid;
reg [2:0]	raw_cnt;
reg [15:0]	raw_data_r1;
reg [15:0]	raw_data_r2;


//================main code============
always@(posedge clk or negedge resetn)begin
	if(!resetn)
		frame_valid <= 1'b0;
	else if(raw_vsync)
		frame_valid <= 1'b1;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		raw_cnt <= 'd0;
	else if(raw_cnt == 'd4 && frame_valid == 1'b1 && raw_vld == 1'b1)
		raw_cnt <= 'd0;
	else if(frame_valid ==1'b1 && raw_vld == 1'b1)
		raw_cnt <= raw_cnt + 1'b1;
end

always@(posedge clk)begin
	raw_data_r1 <= raw_data;
	raw_data_r2 <= raw_data_r1;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		pixel_vld <= 1'b0;
	else if(raw_cnt == 'd4 && frame_valid == 1'b1 && raw_vld == 1'b1)
		pixel_vld <= 1'b1;
	else if(raw_cnt == 'd2 && frame_valid == 1'b1 && raw_vld == 1'b1)
		pixel_vld <= 1'b1;
	else 
		pixel_vld <= 1'b0;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		pixel_data <= 'd0;
	else if(raw_cnt == 'd2 && frame_valid == 1'b1 && raw_vld == 1'b1)
		pixel_data <= {raw_data_r2[7:0] ,raw_data[1:0],
					   raw_data_r2[15:8],raw_data[3:2],
					   raw_data_r1[7:0] ,raw_data[5:4],
					   raw_data_r1[15:8],raw_data[7:6]};
	else if(raw_cnt == 'd4 && frame_valid == 1'b1 && raw_vld == 1'b1)
		pixel_data <= {raw_data_r2[15:8],raw_data[9:8],
					   raw_data_r1[7:0] ,raw_data[11:10],
					   raw_data_r1[15:8],raw_data[13:12],
					   raw_data   [7:0] ,raw_data[15:14]};
end








endmodule