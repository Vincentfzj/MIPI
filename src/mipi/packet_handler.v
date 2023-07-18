module packet_handler(
	//sys
	input 				clk			,
	input				resetn		,
	//word
	input		[15:0]	word_data	,
	input				word_vld	,
	//
	output	reg 		raw_vld		,
	output		[15:0] 	raw_data	,
	output	reg 		raw_vsync	,
	output	reg 		packet_done	
);

//===============define==============
reg 	[15:0] 	word_data_r1;
wire	[31:0]	data_32bit;

wire 	[7:0]	ecc_rlst;
wire	[7:0]	data_type;
reg		[15:0]	wc_reg;
reg 	[15:0]	data_cnt;
reg 	[1:0]	head_cnt;	


//================main code=============
assign data_32bit = {word_data,word_data_r1};
assign data_type = {2'h0,word_data_r1[5:0]};
assign raw_data = (raw_vld == 1'b1) ? word_data : 16'h0;

always@(posedge clk)begin
		word_data_r1 <= word_data;
end
always@(posedge clk or negedge resetn)begin
	if(!resetn)
		raw_vld <= 1'b0;
	else if(raw_vld == 1'b1 && data_cnt == (wc_reg[15:1] - 1))
		raw_vld <= 1'b0;
	else if(word_vld == 1'b1 && head_cnt == 'd2 && ecc_rlst == word_data[15:8] && data_type == 8'h2b)
		raw_vld <= 1'b1;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		wc_reg <= 'd0;
	else if(word_vld == 1'b1 && head_cnt == 'd2 && ecc_rlst == word_data[15:8] && data_type == 8'h2b)
		wc_reg <= data_32bit[23:8];
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		data_cnt <= 'd0;
	else if(raw_vld == 1'b1 && data_cnt == (wc_reg[15:1] - 1))
		data_cnt <= 'd0;
	else if(raw_vld == 1'b1)
		data_cnt <= data_cnt + 1'b1;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn) 
		packet_done <= 1'b0;
	else if(raw_vld == 1'b1 && data_cnt == (wc_reg[15:1] - 1))
		packet_done <= 1'b1;
	else if(word_vld == 1'b1 && head_cnt == 'd2 && data_type != 8'h2b)
		packet_done <= 1'b1;
	// else if(word_vld == 1'b1 && head_cnt == 'd2 && ecc_rlst != word_data[15:8])//B8 != SOT
		// packet_done <= 1'b1;
	// else if(word_vld == 1'b1 && head_cnt == 'd2 && ecc_rlst == word_data[15:8] && data_type <= 8'h17)
		// packet_done <= 1'b1;
	else 
		packet_done <= 1'b0;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		raw_vsync <= 1'b0;
	else if(word_vld == 1'b1 && head_cnt == 'd2 && data_type == 8'h00 && ecc_rlst == word_data[15:8])
		raw_vsync <= 1'b1;
	else
		raw_vsync <= 1'b0;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		head_cnt <= 'd0;
	else if(word_vld == 1'b0)
		head_cnt <= 'd0;
	else if(word_vld == 1'b1 && head_cnt <= 'd2)
		head_cnt <= head_cnt + 1'b1;
end
hdr_ecc hdr_ecc_inst(
        .ph_data   (data_32bit[23:0])              ,       
        .ecc_rlst  (ecc_rlst)                     
);


endmodule