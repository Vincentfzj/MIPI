module  hdmi_top(
        // system signals   
        input                   clk                 ,       
        input                   rst_n                 ,       
        // FIFO
        output  wire            fifo_rd_en              ,       
        input           [15:0]  fifo_rd_data            ,   
        output  wire            vs		,
		output  wire    [ 7:0]  rgb_r          ,
		output  wire    [ 7:0]  rgb_g          ,
		output  wire    [ 7:0]  rgb_b          ,
		output  wire            hs      ,
		output	wire 			de			              
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
//wire    [ 7:0]                  vga_r                           ;       
//wire    [ 7:0]                  vga_g                           ;       
//wire    [ 7:0]                  vga_b                           ;       
//wire                            vga_hsync                       ;       
//wire                            vga_vsync                       ;       


//wire                            vga_de                          ;       

wire                            i_vga_vsync                     ;       
wire                            i_vga_hsync                     ;       
wire                            i_vga_de                        ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================

/* assign  vga_r           =       {fifo_rd_data[15:11], 3'h0};
assign  vga_g           =       {fifo_rd_data[10:05], 2'h0};
assign  vga_b           =       {fifo_rd_data[04:00], 3'h0}; */
// assign  vga_r           =       fifo_rd_data[7:0];
// assign  vga_g           =       fifo_rd_data[7:0];
// assign  vga_b           =       fifo_rd_data[7:0]; 
assign  fifo_rd_en      =       i_vga_de;

raw2rgb         raw2rgb_inst(
        // system signals
        .sclk                   (clk                ),
        .s_rst_n                (rst_n                ),
        // 
        .i_vga_vsync            (i_vga_vsync            ),
        .i_vga_hsync            (i_vga_hsync            ),
        .i_vga_de               (i_vga_de               ),
        .raw_data               (fifo_rd_data[7:0]      ),
        // 
        .o_vga_vsync            (vs              ),
        .o_vga_hsync            (hs              ),
        .o_vga_de               (de                 ),
        .o_vga_r                (rgb_r                  ),
        .o_vga_g                (rgb_g                  ),
        .o_vga_b                (rgb_b                  )
);



v_tc_0 v_tc_0_inst (
        .clk                    (clk                ),      // input wire clk
        .clken                  (1'b1                   ),      // input wire clken
        .gen_clken              (1'b1                   ),      // input wire gen_clken
        .hsync_out              (i_vga_hsync            ),      // output wire hsync_out
        .hblank_out             (                       ),      // output wire hblank_out
        .vsync_out              (i_vga_vsync            ),      // output wire vsync_out
        .vblank_out             (                       ),      // output wire vblank_out
        .active_video_out       (i_vga_de               ),      // output wire active_video_out
        .resetn                 (rst_n                ),      // input wire rst_n
        .fsync_out              (                       )       // output wire [0 : 0] fsync_out
);



endmodule
