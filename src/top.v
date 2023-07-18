module top(

	// Memory interface ports
		output                         	ddr4_act_n   ,
		output [16:0]                  	ddr4_adr     ,
		output [1:0]                   	ddr4_ba      ,
		output [0:0]                   	ddr4_bg      ,
		output [0:0]                   	ddr4_cke     ,
		output [0:0]                   	ddr4_odt     ,
		output [0:0]                   	ddr4_cs_n    ,
		output [0:0]                   	ddr4_ck_t    ,
		output [0:0]                   	ddr4_ck_c    ,
		output                         	ddr4_reset_n ,
		inout [1:0]                    	ddr4_dm_dbi_n,
		inout [15:0]                   	ddr4_dq      ,
		inout [1:0]                    	ddr4_dqs_c   ,
		inout [1:0]                    	ddr4_dqs_t   ,               
	
        // system signals
        input                   		clk_200mhz_p    ,
        input                   		clk_200mhz_n    ,       
        input                   		sys_rst_n       ,
													  
	    input                   		rs232_rx		,
		
		       
		       
		output 	[ 23:0]                 hdmi_d         ,       
		output 							hdmi_hs        ,       
		output 							hdmi_vs        ,
		output							hdmi_de			,
		output							hdmi_clk		,
		inout                    		hdmi_scl		,
		inout                    		hdmi_sda	 	,
		// MIPI
		input           		        mipi_clk_p        ,
		input           		        mipi_clk_n        ,
		input           		[ 1:0]  mipi_data_p       ,
		input           		[ 1:0]  mipi_data_n       ,
		inout		    		        mipi_scl          , 
		inout           		        mipi_sda          , 
		output  wire    		        mipi_gpio           
		
		
);

//=========================define===================
		wire    [ 3:0]  m_axi_awid              ;
        wire    [27:0]  m_axi_awaddr            ;
        wire    [ 7:0]  m_axi_awlen             ;
        wire    [ 2:0]  m_axi_awsize            ;
        wire    [ 1:0]  m_axi_awburst           ;
        wire            m_axi_awlock            ;       
        wire    [ 3:0]  m_axi_awcache           ;
        wire    [ 2:0]  m_axi_awprot            ;
        wire    [ 3:0]  m_axi_awqos             ;
        wire            m_axi_awvalid           ;
        wire            m_axi_awready           ;
        // Write Data Ports                         
        wire    [127:0] m_axi_wdata             ;
        wire    [15:0]  m_axi_wstrb             ;
        wire            m_axi_wlast             ;
        wire            m_axi_wvalid            ;
        wire            m_axi_wready            ;
        // Write Response Ports                       
		wire     [ 3:0]  m_axi_bid              ;
		wire     [ 1:0]  m_axi_bresp            ;
		wire             m_axi_bvalid           ;
		wire             m_axi_bready           ;
        // Read Address Ports                      
        wire    [ 3:0]  m_axi_arid              ;
        wire    [27:0]  m_axi_araddr            ;
        wire    [ 7:0]  m_axi_arlen             ;
        wire    [ 2:0]  m_axi_arsize            ;
        wire    [ 1:0]  m_axi_arburst           ;
        wire            m_axi_arlock            ;
        wire    [ 3:0]  m_axi_arcache           ;
        wire    [ 2:0]  m_axi_arprot            ;
        wire    [ 3:0]  m_axi_arqos             ;
        wire            m_axi_arvalid           ;
        wire            m_axi_arready           ;
        // Read Data Ports
        wire    [ 3:0]  m_axi_rid               ;
        wire    [127:0] m_axi_rdata             ;
        wire    [ 1:0]  m_axi_rresp             ;
        wire            m_axi_rlast             ;
        wire            m_axi_rvalid            ;
        wire            m_axi_rready            ;
 
//wire            	fifo_rd_en             ;       
//wire        [15:0]  fifo_rd_data           ;
wire 							ui_clk					;
wire							init_calib_complete		;

wire    [ 7:0]                  rx_data                         ;       
wire                            rx_data_vld                     ;   
wire    [127:0]                 wfifo_rd_data                   ;
wire                            wfifo_rd_en                     ;       
wire                            wr_trig                         ;    
// RFIFO
wire                            rfifo_wr_en                     ;       
wire    [127:0]                 rfifo_wr_data                   ;       

wire                            rd_trig                         ;       

wire                            rfifo_rd_en                     ;       
wire    [15:0]                  rfifo_rd_data                   ; 
 

wire							clk_100m;
wire 							clk_200m;
wire 							sys_100m;
wire							sys_200m;    
wire        					pll0_locked                     ;  
wire							pll1_locked;
wire 							sys_148p5m  ;
wire							sys_400m;


wire[7:0]                       video_r;
wire[7:0]                       video_g;
wire[7:0]                       video_b;


wire[9:0]                       lut_index;
wire[31:0]                      lut_data;
wire [9:0]   					lut_index_mipi      ;
wire [31:0]						lut_data_mipi;	

wire                            cfg_done          ;       
wire                            pixel_clk         ;       
wire                            pixel_vld         ;       
wire    [39:0]                  pixel_data  ;

	
//=========================main code=========
wire   hdmi_start;
wire   mipi_start;
assign hdmi_start = init_calib_complete;
assign mipi_start = init_calib_complete;

wire clk_400_r;
assign clk_400_r = sys_400m;

//assign hdmi_de = rfifo_rd_en;
assign hdmi_clk = sys_148p5m;
assign hdmi_d = {video_r,video_g,video_b};


 clk_wiz_0 clk_wiz_0_inst
   (
    // Clock out ports
    .clk_100(sys_100m),     // output clk_out1
    .clk_400(sys_400m),     // output clk_out2
    .clk_200(sys_200m),     // output clk_out3
    // Status and control signals
    //.reset(~sys_rst_n), // input reset
    .locked(pll0_locked),       // output locked
   // Clock in ports
	.clk_in1(clk_200m));	// input clk_in1

clk_wiz_1 clk_wiz_1_inst
   (
    // Clock out ports
    .clk_148(sys_148p5m),     // output clk_out1
    // Status and control signals
    //.reset(~sys_rst_n), // input reset
    .locked(pll1_locked),       // output locked
   // Clock in ports
	.clk_in1(clk_100m));

/*
uart_rx         uart_rx_inst(
        // system signals
        .sclk                   (  sys_50m              ),
        .s_rst_n                (pll0_locked            ),
        // RS232
        .rs232_rx               (rs232_rx               ),
        // 
        .rx_data                (rx_data                ),
        .rx_data_vld            (rx_data_vld            )
);*/
mipi_top        mipi_top_inst(
        // system signals
        .resetn                (pll0_locked & cfg_done & mipi_start),
		.clk_400m				(sys_400m),
        // 
        .mipi_clk_p             (mipi_clk_p             ),
        .mipi_clk_n             (mipi_clk_n             ),
        .mipi_data_p            (mipi_data_p            ),
        .mipi_data_n            (mipi_data_n            ),
        // 
        .pixel_clk              (pixel_clk              ),       
        .pixel_vld              (pixel_vld              ),       
        .pixel_data             (pixel_data             )       //      
);


//hdmi_top_rgb hdmi_top
hdmi_top hdmi_inst(
	.clk                     (sys_148p5m              ),
	.rst_n                   (hdmi_start & pll1_locked                          ),
	.fifo_rd_en              (rfifo_rd_en  				),
	.fifo_rd_data            (rfifo_rd_data				),
	.hs                      (hdmi_hs                   ),
	.vs                      (hdmi_vs                   ),
	.de                      (hdmi_de                   ),
	.rgb_r                   (video_r                    ),
	.rgb_g                   (video_g                    ),
	.rgb_b                   (video_b                    )
);

//i2c_config_ov5640    i2c_config_ov5640_delay i2c_config_ov5640_delayandzero
i2c_config_ov5640 i2c_config_m1(
	.rst                        (~pll0_locked              ),
	.clk                        (sys_200m               ),//200m
	.clk_div_cnt                (16'd499                  ),//499
	.i2c_addr_2byte             (1'b1                     ),
	.lut_index                  (lut_index_mipi                ),
	.lut_dev_addr               (lut_data_mipi[31:24]          ),
	.lut_reg_addr               (lut_data_mipi[23:8]           ),
	.lut_reg_data               (lut_data_mipi[7:0]            ),
	.error                      (                         ),
	.done                       (                         ),
	.i2c_scl                    (mipi_scl                 ),
	.i2c_sda                    (mipi_sda                 ),
	.cfg_done					(cfg_done)
);
//configure look-up table //lut_ov5640  lut_ov5640_delay lut_ov5640_delayandzero
lut_ov5640 lut_ov5640_m1(
	.lut_index                  (lut_index_mipi                ),
	.lut_data                   (lut_data_mipi                 )
); 



//I2C master controller
i2c_config i2c_config_m0(
	.rst                        (~pll0_locked              ),
	.clk                        (sys_100m               ),
	.clk_div_cnt                (16'd499                  ),
	.i2c_addr_2byte             (1'b0                     ),
	.lut_index                  (lut_index                ),
	.lut_dev_addr               (lut_data[31:24]          ),
	.lut_reg_addr               (lut_data[23:8]           ),
	.lut_reg_data               (lut_data[7:0]            ),
	.error                      (                         ),
	.done                       (                         ),
	.i2c_scl                    (hdmi_scl                 ),
	.i2c_sda                    (hdmi_sda                 )
);
//configure look-up table
lut_adv7511 lut_adv7511_m0(
	.lut_index                  (lut_index                ),
	.lut_data                   (lut_data                 )
); 


fifo_ctrl       fifo_ctrl_inst(
        // system signals
        .s_rst_n                (pll0_locked            ),
        // UART
        .pixel_data           	(pixel_data         ),
        .pixel_vld            	(pixel_vld          ),
        // WFIFO
        .wfifo_wr_clk           (pixel_clk                ),

        .wfifo_rd_clk           (ui_clk                 ),//ui_clk
        .wfifo_rd_en            (wfifo_rd_en            ),
        .wfifo_rd_data          (wfifo_rd_data          ),
        .wr_trig                (wr_trig                ),
        // RFIFO
        .rfifo_wr_clk           (ui_clk                 ),//ui_clk
        .rfifo_wr_en            (rfifo_wr_en            ),
        .rfifo_wr_data          (rfifo_wr_data          ),

        .rd_trig                (rd_trig                ),
		.hdmi_vs				(hdmi_vs),
        .rfifo_rd_clk           (sys_148p5m             ),
        .rfifo_rd_en            (rfifo_rd_en            ),
        .rfifo_rd_data          (rfifo_rd_data          )
);

axi4_master_ctrl axi4_master_ctrl_inst(
		//sys signals
		.sclk					(ui_clk			),//ui_clk
		.s_rst_n				(pll0_locked)	,//init_calib_complete
		// Write Address Ports
       .m_axi_awid              (m_axi_awid   ),
       .m_axi_awaddr            (m_axi_awaddr ),
       .m_axi_awlen             (m_axi_awlen  ),
       .m_axi_awsize            (m_axi_awsize ),
       .m_axi_awburst           (m_axi_awburst),
       .m_axi_awlock            (m_axi_awlock ),       
       .m_axi_awcache           (m_axi_awcache),
       .m_axi_awprot            (m_axi_awprot ),
       .m_axi_awqos             (m_axi_awqos  ),
       .m_axi_awvalid           (m_axi_awvalid),
       .m_axi_awready           (m_axi_awready),
        // Write Data Ports                             
        .m_axi_wdata            (m_axi_wdata  ) ,
        .m_axi_wstrb            (m_axi_wstrb  ) ,
        .m_axi_wlast            (m_axi_wlast  ) ,
        .m_axi_wvalid           (m_axi_wvalid ) ,
        .m_axi_wready           (m_axi_wready ) ,
        // Write Response Ports                         
        .m_axi_bid              (m_axi_bid    ),
        .m_axi_bresp            (m_axi_bresp  ),
        .m_axi_bvalid           (m_axi_bvalid ),
        .m_axi_bready           (m_axi_bready ),
        // Read Address Ports                            
        .m_axi_arid              (m_axi_arid    ),
        .m_axi_araddr            (m_axi_araddr  ),
        .m_axi_arlen             (m_axi_arlen   ),
        .m_axi_arsize            (m_axi_arsize  ),
        .m_axi_arburst           (m_axi_arburst ),
        .m_axi_arlock            (m_axi_arlock  ),
        .m_axi_arcache           (m_axi_arcache ),
        .m_axi_arprot            (m_axi_arprot  ),
        .m_axi_arqos             (m_axi_arqos   ),
        .m_axi_arvalid           (m_axi_arvalid ),
        .m_axi_arready           (m_axi_arready ),
        // Read Data Ports                              
        .m_axi_rid               (m_axi_rid   ),
        .m_axi_rdata             (m_axi_rdata ),
        .m_axi_rresp             (m_axi_rresp ),
        .m_axi_rlast             (m_axi_rlast ),
        .m_axi_rvalid            (m_axi_rvalid),
        .m_axi_rready            (m_axi_rready),
        //WFIFO
        .wr_trig                (wr_trig                ),
        .wfifo_rd_en            (wfifo_rd_en            ),
        .wfifo_rd_data          (wfifo_rd_data          ),
        // RFIFO
		.hdmi_vs				(hdmi_vs),
        .rd_trig                (rd_trig                ),
        .rfifo_wr_en            (rfifo_wr_en            ),
        .rfifo_wr_data          (rfifo_wr_data          )
);
ddr4_0 ddr4_0_inst (
  .c0_init_calib_complete	(init_calib_complete),			    // output wire c0_init_calib_complete
                			// output wire dbg_clk
  .c0_sys_clk_p(clk_200mhz_p),      			       // input wire c0_sys_clk_p
  .c0_sys_clk_n(clk_200mhz_n),
                 			// output wire [511 : 0] dbg_bus
  .c0_ddr4_adr				(ddr4_adr		),               // output wire [16 : 0] c0_ddr4_adr
  .c0_ddr4_ba				(ddr4_ba		    ),                // output wire [1 : 0] c0_ddr4_ba
  .c0_ddr4_cke				(ddr4_cke		),               // output wire [0 : 0] c0_ddr4_cke
  .c0_ddr4_cs_n				(ddr4_cs_n		),              // output wire [0 : 0] c0_ddr4_cs_n
  .c0_ddr4_dm_dbi_n			(ddr4_dm_dbi_n	),          // inout wire [1 : 0] c0_ddr4_dm_dbi_n
  .c0_ddr4_dq				(ddr4_dq		    ),                // inout wire [15 : 0] c0_ddr4_dq
  .c0_ddr4_dqs_c			(ddr4_dqs_c	    ),             // inout wire [1 : 0] c0_ddr4_dqs_c
  .c0_ddr4_dqs_t			(ddr4_dqs_t	    ),             // inout wire [1 : 0] c0_ddr4_dqs_t
  .c0_ddr4_odt				(ddr4_odt		),               // output wire [0 : 0] c0_ddr4_odt
  .c0_ddr4_bg				(ddr4_bg		    ),                // output wire [0 : 0] c0_ddr4_bg
  .c0_ddr4_reset_n			(ddr4_reset_n	),           // output wire c0_ddr4_reset_n
  .c0_ddr4_act_n			(ddr4_act_n	    ),             // output wire c0_ddr4_act_n
  .c0_ddr4_ck_c				(ddr4_ck_c		),              // output wire [0 : 0] c0_ddr4_ck_c
  .c0_ddr4_ck_t				(ddr4_ck_t		),              // output wire [0 : 0] c0_ddr4_ck_t
  .c0_ddr4_ui_clk			(ui_clk		),            // output wire c0_ddr4_ui_clk
  .c0_ddr4_ui_clk_sync_rst	(),   // output wire c0_ddr4_ui_clk_sync_rst
  .c0_ddr4_aresetn			(pll0_locked),           // input wire c0_ddr4_aresetn
  .c0_ddr4_s_axi_awid		(m_axi_awid),        // input wire [3 : 0] c0_ddr4_s_axi_awid
  .c0_ddr4_s_axi_awaddr		(m_axi_awaddr),      // input wire [29 : 0] c0_ddr4_s_axi_awaddr
  .c0_ddr4_s_axi_awlen		(m_axi_awlen),       // input wire [7 : 0] c0_ddr4_s_axi_awlen
  .c0_ddr4_s_axi_awsize		(m_axi_awsize),      // input wire [2 : 0] c0_ddr4_s_axi_awsize
  .c0_ddr4_s_axi_awburst	(m_axi_awburst),     // input wire [1 : 0] c0_ddr4_s_axi_awburst
  .c0_ddr4_s_axi_awlock		(m_axi_awlock),      // input wire [0 : 0] c0_ddr4_s_axi_awlock
  .c0_ddr4_s_axi_awcache	(m_axi_awcache),     // input wire [3 : 0] c0_ddr4_s_axi_awcache
  .c0_ddr4_s_axi_awprot		(m_axi_awprot),      // input wire [2 : 0] c0_ddr4_s_axi_awprot
  .c0_ddr4_s_axi_awqos		(m_axi_awqos),       // input wire [3 : 0] c0_ddr4_s_axi_awqos
  .c0_ddr4_s_axi_awvalid	(m_axi_awvalid),     // input wire c0_ddr4_s_axi_awvalid
  .c0_ddr4_s_axi_awready	(m_axi_awready),     // output wire c0_ddr4_s_axi_awready
  .c0_ddr4_s_axi_wdata		(m_axi_wdata),       // input wire [127 : 0] c0_ddr4_s_axi_wdata
  .c0_ddr4_s_axi_wstrb		(m_axi_wstrb),       // input wire [15 : 0] c0_ddr4_s_axi_wstrb
  .c0_ddr4_s_axi_wlast		(m_axi_wlast),       // input wire c0_ddr4_s_axi_wlast
  .c0_ddr4_s_axi_wvalid		(m_axi_wvalid),      // input wire c0_ddr4_s_axi_wvalid
  .c0_ddr4_s_axi_wready		(m_axi_wready),      // output wire c0_ddr4_s_axi_wready
  .c0_ddr4_s_axi_bready		(m_axi_bready),      // input wire c0_ddr4_s_axi_bready
  .c0_ddr4_s_axi_bid		(m_axi_bid),         // output wire [3 : 0] c0_ddr4_s_axi_bid
  .c0_ddr4_s_axi_bresp		(m_axi_bresp),       // output wire [1 : 0] c0_ddr4_s_axi_bresp
  .c0_ddr4_s_axi_bvalid		(m_axi_bvalid),      // output wire c0_ddr4_s_axi_bvalid
  .c0_ddr4_s_axi_arid		(m_axi_arid),        // input wire [3 : 0] c0_ddr4_s_axi_arid
  .c0_ddr4_s_axi_araddr		(m_axi_araddr),      // input wire [29 : 0] c0_ddr4_s_axi_araddr
  .c0_ddr4_s_axi_arlen		(m_axi_arlen),       // input wire [7 : 0] c0_ddr4_s_axi_arlen
  .c0_ddr4_s_axi_arsize		(m_axi_arsize),      // input wire [2 : 0] c0_ddr4_s_axi_arsize
  .c0_ddr4_s_axi_arburst	(m_axi_arburst),     // input wire [1 : 0] c0_ddr4_s_axi_arburst
  .c0_ddr4_s_axi_arlock		(m_axi_arlock),      // input wire [0 : 0] c0_ddr4_s_axi_arlock
  .c0_ddr4_s_axi_arcache	(m_axi_arcache),     // input wire [3 : 0] c0_ddr4_s_axi_arcache
  .c0_ddr4_s_axi_arprot		(m_axi_arprot),      // input wire [2 : 0] c0_ddr4_s_axi_arprot
  .c0_ddr4_s_axi_arqos		(m_axi_arqos),       // input wire [3 : 0] c0_ddr4_s_axi_arqos
  .c0_ddr4_s_axi_arvalid	(m_axi_arvalid),     // input wire c0_ddr4_s_axi_arvalid
  .c0_ddr4_s_axi_arready	(m_axi_arready),     // output wire c0_ddr4_s_axi_arready
  .c0_ddr4_s_axi_rready		(m_axi_rready),      // input wire c0_ddr4_s_axi_rready
  .c0_ddr4_s_axi_rlast		(m_axi_rlast),       // output wire c0_ddr4_s_axi_rlast
  .c0_ddr4_s_axi_rvalid		(m_axi_rvalid),      // output wire c0_ddr4_s_axi_rvalid
  .c0_ddr4_s_axi_rresp		(m_axi_rresp),       // output wire [1 : 0] c0_ddr4_s_axi_rresp
  .c0_ddr4_s_axi_rid		(m_axi_rid),         // output wire [3 : 0] c0_ddr4_s_axi_rid
  .c0_ddr4_s_axi_rdata		(m_axi_rdata),       // output wire [127 : 0] c0_ddr4_s_axi_rdata
  .addn_ui_clkout1(clk_200m),
  .addn_ui_clkout2(clk_100m),   
  .dbg_clk                    (                          ),
  .dbg_bus                    (                          ),
  .sys_rst					(		)                   // input wire sys_rst
);
endmodule