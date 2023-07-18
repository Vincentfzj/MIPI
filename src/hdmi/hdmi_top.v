module  hdmi_top(
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
     

     

//=============================================================================
//**************    Main Code   **************
//=============================================================================

// assign rgb_r            =       {fifo_rd_data[15:11], 3'h0};
// assign rgb_g            =       {fifo_rd_data[10:05], 2'h0};
// assign rgb_b            =       {fifo_rd_data[04:00], 3'h0};

assign rgb_r            =       fifo_rd_data[7:0];
assign rgb_g            =       fifo_rd_data[7:0];
assign rgb_b            =       fifo_rd_data[7:0];

assign fifo_rd_en      =       de;


v_tc_0 v_tc_0_inst (
        .clk                    (clk                ),      // input wire clk
        .clken                  (1'b1                   ),      // input wire clken
        .gen_clken              (1'b1                   ),      // input wire gen_clken
        .hsync_out              (hs              ),      // output wire hsync_out
        .hblank_out             (                       ),      // output wire hblank_out
        .vsync_out              (vs              ),      // output wire vsync_out
        .vblank_out             (                       ),      // output wire vblank_out
        .active_video_out       (de                 ),      // output wire active_video_out
        .resetn                 (rst_n                ),      // input wire resetn
        .fsync_out              (                       )       // output wire [0 : 0] fsync_out
);



endmodule
