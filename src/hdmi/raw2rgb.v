module raw2rgb(
	input 					clk			,
	input					resetn		,
				
	input					hdmi_hs		,
	input					hdmi_vs		,
	input					hdmi_de		,
	input 			[7:0]	raw_data	,
	//		
	output	reg				hdmi_de_o	,
	output	reg				hdmi_hs_o	,
	output	reg				hdmi_vs_o	,
	output 	reg 	[7:0]	hdmi_r_o,
	output 	reg 	[7:0]	hdmi_g_o,
	output 	reg 	[7:0]	hdmi_b_o
);

//==================define
reg [7:0]	raw_data_r1;
wire		fifo_rd_en;
wire [7:0]	fifo_rd_data;
reg [7:0]	fifo_rd_data_r1;

reg [15:0]	raw_cnt;
reg [15:0]	col_cnt;

wire	[8:0]	sum0;
wire	[8:0]	sum1;
//=========main code
always@(posedge clk)begin
	hdmi_hs_o		<=	hdmi_hs;
	hdmi_vs_o		<= 	hdmi_vs;
	hdmi_de_o		<= 	hdmi_de;	
	raw_data_r1		<= 	raw_data;
	fifo_rd_data_r1	<=	fifo_rd_data;
end


always@(posedge clk or negedge resetn)begin
	if(!resetn)
		raw_cnt	<= 'd0;
	else if(hdmi_vs)
		raw_cnt <= 'd0;
	else if(hdmi_de == 1'b0 && hdmi_de_o == 1'b1)
		raw_cnt <= raw_cnt + 1'b1;	
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)
		col_cnt	<= 'd0;
	else if(hdmi_de == 1'b1)
		col_cnt <= col_cnt + 1'b1;	
	else
		col_cnt <= 'd0;
end

always@(posedge clk or negedge resetn)begin
	if(!resetn)begin
		hdmi_r_o	<= 8'h0;
		hdmi_g_o	<= 8'h0;
		hdmi_b_o	<= 8'h0;
	end
	else if(hdmi_de == 1'b1)begin
		case({raw_cnt[0],col_cnt[0]})
			2'b00:begin//RGGB
				hdmi_r_o	<= fifo_rd_data_r1;
				hdmi_g_o	<= sum0[8:1];
				hdmi_b_o	<= raw_data;
			end
			2'b10:begin//GBRG
				hdmi_r_o	<= raw_data_r1;
				hdmi_g_o	<= sum1[8:1];
				hdmi_b_o	<= fifo_rd_data;
			end
			2'b01:begin	//GRBG
				hdmi_r_o	<= fifo_rd_data;
				hdmi_g_o	<= sum1[8:1];
				hdmi_b_o	<= raw_data_r1;
			end
			2'b11:begin	//BGGR
				hdmi_r_o	<= raw_data;
				hdmi_g_o	<= sum0[8:1];
				hdmi_b_o	<= fifo_rd_data_r1;
			end
		endcase
	end
	else begin
		hdmi_r_o	<= 8'h0;
		hdmi_g_o	<= 8'h0;
		hdmi_b_o	<= 8'h0;
	end
end

fifo_generator_0 fifo_generator_0_inst (
  .clk			(clk),                  // input wire clk
  .srst			(hdmi_vs),                // input wire srst
  .din			(raw_data),                  // input wire [7 : 0] din
  .wr_en		(hdmi_de),              // input wire wr_en
  .rd_en		(fifo_rd_en),              // input wire rd_en
  .dout			(fifo_rd_data),                // output wire [7 : 0] dout
  .full			(),                // output wire full
  .empty		(),              // output wire empty
  .wr_rst_busy	(),  // output wire wr_rst_busy
  .rd_rst_busy	()  // output wire rd_rst_busy
);


assign sum0 = fifo_rd_data + raw_data_r1;
assign sum1 = fifo_rd_data_r1 + raw_data;

assign fifo_rd_en = (raw_cnt >= 'd1) ? hdmi_de : 1'b0;

endmodule