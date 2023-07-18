module  hdmi_top_rgb(
        // system signals
          
        input                   clk                 ,       
        input                   rst_n                 ,       
        // FIFO
        output  wire            fifo_rd_en              ,       
        input           [15:0]  fifo_rd_data            ,       
        // HDMI
        output hs,            //行同步、高有效
		output vs,            //场同步、高有效
		output de,            //数据有效
		output[7:0] rgb_r,    //像素数据、红色分量
		output[7:0] rgb_g,    //像素数据、绿色分量
		output[7:0] rgb_b     //像素数据、蓝色分量             
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
    
wire hs_vtc;
wire vs_vtc;
wire de_vtc;	
wire raw_data;
//=============================================================================
//**************    Main Code   **************
//=============================================================================

// assign rgb_r            =       {fifo_rd_data[15:11], 3'h0};
// assign rgb_g            =       {fifo_rd_data[10:05], 2'h0};
// assign rgb_b            =       {fifo_rd_data[04:00], 3'h0};

//assign rgb_r            =       fifo_rd_data[7:0];
//assign rgb_g            =       fifo_rd_data[7:0];
//assign rgb_b            =       fifo_rd_data[7:0];

assign fifo_rd_en      =       de_vtc;
assign raw_data = fifo_rd_data[7:0];


raw2rgb raw2rgb_inst(
	.clk		(clk		)	,
	.resetn		(rst_n		),
				
	.hdmi_hs	(hs_vtc	)	,
	.hdmi_vs	(vs_vtc	)	,
	.hdmi_de	(de_vtc	)	,
	.raw_data	(raw_data	),
			
	.hdmi_de_o	(de			),
	.hdmi_hs_o	(hs			),
	.hdmi_vs_o	(vs			),
	.hdmi_r_o	(rgb_r		),
	.hdmi_g_o	(rgb_g		),
	.hdmi_b_o   (rgb_b   	)
);





v_tc_0 v_tc_0_inst (
        .clk                    (clk                ),      // input wire clk
        .clken                  (1'b1                   ),      // input wire clken
        .gen_clken              (1'b1                   ),      // input wire gen_clken
        .hsync_out              (hs_vtc              ),      // output wire hsync_out
        .hblank_out             (                       ),      // output wire hblank_out
        .vsync_out              (vs_vtc              ),      // output wire vsync_out
        .vblank_out             (                       ),      // output wire vblank_out
        .active_video_out       (de_vtc                 ),      // output wire active_video_out
        .resetn                 (rst_n                ),      // input wire resetn
        .fsync_out              (                       )       // output wire [0 : 0] fsync_out
);



endmodule
