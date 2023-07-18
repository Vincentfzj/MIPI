/*
	验证思路
	对解析出的图像数据量进行验证，定义row_cnt


*/


module mipi_check(
							input 			clk	,
							input			resetn,
	//
	(* MARK_DEBUG="true" *) input			raw_vld	,
	(* MARK_DEBUG="true" *) input 	[15:0]	raw_data,
	(* MARK_DEBUG="true" *) input			raw_vsync,
	//mipi
	(* MARK_DEBUG="true" *) input	[7:0]	lane0_data		,
	(* MARK_DEBUG="true" *) input	[7:0]	lane1_data		,
	(* MARK_DEBUG="true" *) input 	[7:0]	lane0_byte_data,
	(* MARK_DEBUG="true" *) input 			lane0_byte_vld ,
	(* MARK_DEBUG="true" *) input 	[7:0]	lane1_byte_data,
	(* MARK_DEBUG="true" *) input 			lane1_byte_vld	,
	(* MARK_DEBUG="true" *) input	[15:0]	word_data		,
	(* MARK_DEBUG="true" *) input			word_vld		,
	(* MARK_DEBUG="true" *) input			invalid_start	,
	(* MARK_DEBUG="true" *) input			packet_done

	

);

//========================================
(* MARK_DEBUG="true" *) reg [15:0]		row_cnt;
reg 			raw_vld_r1;

(* MARK_DEBUG="true" *) wire 			raw_vld_pos;

(* MARK_DEBUG="true" *) reg				row_err;
(* MARK_DEBUG="true" *) reg	[7:0]		row_err_cnt;
//============main code============
always@(posedge clk)begin
		raw_vld_r1 <= raw_vld;
end

assign  raw_vld_pos = ~raw_vld_r1 & raw_vld;

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		row_cnt <= 'd0;
	else if(raw_vsync == 1'b1)
		row_cnt <= 'd0;
	else if(raw_vld_pos == 1'b1)
		row_cnt <= row_cnt +1'b1;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		row_err <= 'd0;
	else if(raw_vsync == 1'b1 && row_cnt != 'd1080)
		row_err <= 1'b1;
	else	
		row_err <= 1'b0;
end


always@(posedge clk or negedge resetn)begin
	if(!resetn)
		row_err_cnt <= 'd0;
	else if(row_err == 1'b1)
		row_err_cnt <= row_err_cnt + 1'b1;
end




endmodule