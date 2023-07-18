module fifo_ctrl(
	//sys
	input				s_rst_n				,
	//uart
	input	[39:0]		pixel_data		,
	input				pixel_vld			,
	//wfifo
	input				wfifo_wr_clk		,
	
	input				wfifo_rd_clk		,
	input				wfifo_rd_en			,
	output	[127:0]		wfifo_rd_data		, 
	output				wr_trig				,
	//rfifo
	input				rfifo_wr_clk		,
	input				rfifo_wr_en			,
	input	[127:0]		rfifo_wr_data		,
	
	output				rd_trig				,
	input				hdmi_vs				,
	input				rfifo_rd_clk		,
	input				rfifo_rd_en			,
	output	[15:0]		rfifo_rd_data		
);

//================define============
reg			wfifo_wr_en;
reg	[127:0]	wfifo_wr_data;
reg				byte_cnt;
wire [4:0]	wfifo_data_count;

wire [ 4:0]	rfifo_data_count;

wire [63:0]	pixel_64bit;

assign pixel_64bit = {	pixel_data[39:32],pixel_data[39:32],
						pixel_data[29:22],pixel_data[29:22],		
						pixel_data[19:12],pixel_data[19:12],	
						pixel_data[09:02],pixel_data[09:02]};
						


//================main code===========
//wfifo
assign  wr_trig =       (wfifo_data_count >= 'd16) ? 1'b1 : 1'b0;


always@(posedge wfifo_wr_clk or negedge s_rst_n)begin
	if(!s_rst_n)
		byte_cnt	<= 'd0;
	else if(byte_cnt == 1'b1 && pixel_vld)
		byte_cnt	<= 'd0;
	else if(pixel_vld)
		byte_cnt 	<= byte_cnt + 1'b1;
end

always@(posedge wfifo_wr_clk or negedge s_rst_n)begin
	if(!s_rst_n)
		wfifo_wr_en	<= 1'b0;
	else if(byte_cnt == 1'b1 && pixel_vld)
		wfifo_wr_en	<= 1'b1;
	else
		wfifo_wr_en	<= 1'b0;
end

always@(posedge wfifo_wr_clk or negedge s_rst_n)begin
	if(!s_rst_n)
		wfifo_wr_data	<= 'd0;
	else if(pixel_vld)
		wfifo_wr_data 	<= {wfifo_wr_data[63:0],pixel_64bit};
end

assign rd_trig = (rfifo_data_count < 'd16) ? 1'b1 : 1'b0;


wfifo_ip wfifo_ip_inst (
  .rst				(~s_rst_n			),                      // input wire rst
  .wr_clk			(wfifo_wr_clk			),                // input wire wr_clk
  .rd_clk			(wfifo_rd_clk			),                // input wire rd_clk
  .din				(wfifo_wr_data			),                      // input wire [127 : 0] din
  .wr_en			(wfifo_wr_en			),                  // input wire wr_en
  .rd_en			(wfifo_rd_en			),                  // input wire rd_en
  .dout				(wfifo_rd_data			),                    // output wire [127 : 0] dout
  .full				(			),                    // output wire full
  .empty			(			),                  // output wire empty
  .rd_data_count	(wfifo_data_count	),  // output wire [4 : 0] rd_data_count
  .wr_rst_busy		(	),      // output wire wr_rst_busy
  .rd_rst_busy		(	)      // output wire rd_rst_busy
);


rfifo_ip rfifo_ip_inst (
  .rst					(hdmi_vs	), //~s_rst_n hdmi_vs                     // input wire rst
  .wr_clk				(rfifo_wr_clk),                // input wire wr_clk
  .rd_clk				(rfifo_rd_clk),                // input wire rd_clk
  .din					(rfifo_wr_data),                      // input wire [127 : 0] din
  .wr_en				(rfifo_wr_en),                  // input wire wr_en
  .rd_en				(rfifo_rd_en),                  // input wire rd_en
  .dout					(rfifo_rd_data),                    // output wire [15 : 0] dout
  .full					(),                    // output wire full
  .empty				(),                  // output wire empty
  .wr_data_count		(rfifo_data_count),  // output wire [4 : 0] wr_data_count
  .wr_rst_busy			(),      // output wire wr_rst_busy
  .rd_rst_busy			()      // output wire rd_rst_busy
);


endmodule