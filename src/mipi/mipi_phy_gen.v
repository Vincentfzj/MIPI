module mipi_phy_gen(
	//
	input			resetn			,
	input			mipi_clk_p		,
	input			mipi_clk_n		,
	input	[1:0]	mipi_data_p		,
	input	[1:0]	mipi_data_n		,
	
	//
	output 			mipi_byte_clk	,
	output	[7:0]	lane0_byte_data	,
	output	[7:0]	lane1_byte_data
    );
	
	
//clock

wire			clk_in_int;
wire 			clk_div;

wire			clk_in_int_bufg;

 IBUFDS_DPHY #(
      .DIFF_TERM("TRUE"),             // Differential termination
      .IOSTANDARD("MIPI_DPHY_DCI"),         // I/O standard
      .SIM_DEVICE("ULTRASCALE_PLUS")  // Set the device version (ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1,
                                      // ULTRASCALE_PLUS_ES2)
   )
   IBUFDS_DPHY_inst_uclk (
      .HSRX_O(clk_in_int_bufg),             // 1-bit output: HS RX output
      .LPRX_O_N(),         // 1-bit output: LP RX output (Slave)
      .LPRX_O_P(),         // 1-bit output: LP RX output (Master)
      .HSRX_DISABLE(1'b0), // 1-bit input: Disable control for HS mode
      .I(mipi_clk_p),                       // 1-bit input: Data input0 PAD
      .IB(mipi_clk_n),                     // 1-bit input: Data input1 PAD
      .LPRX_DISABLE(1'b1)  // 1-bit input: Disable control for LP mode
   );

BUFG BUFG_inst (
        .O                              (clk_in_int                      ),  // 1-bit output: Clock output
        .I                              (clk_in_int_bufg                          )   // 1-bit input: Clock input
    );


	 
 BUFGCE_DIV #(
      .BUFGCE_DIVIDE(4),      // 1-8
      // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
      .IS_CE_INVERTED(1'b0),  // Optional inversion for CE
      .IS_CLR_INVERTED(1'b0), // Optional inversion for CLR
      .IS_I_INVERTED(1'b0)    // Optional inversion for I
   )
   BUFGCE_DIV_inst (
      .O(clk_div),     // 1-bit output: Buffer
      .CE(1'b1),   // 1-bit input: Buffer enable
      .CLR(1'b0), // 1-bit input: Asynchronous clear
      .I(clk_in_int_bufg)      // 1-bit input: Buffer
   );
	 
assign mipi_byte_clk = clk_div;

//data
wire	[1:0]	data_in_from_pins_int;
wire	[7:0]	lane_byte_data[0:1];
assign lane0_byte_data = lane_byte_data[0];
assign lane1_byte_data = lane_byte_data[1];
genvar i;
generate
	for(i=0;i<2;i=i+1)begin:gen
		IBUFDS_DPHY #(
			.DIFF_TERM("TRUE"),             // Differential termination
			.IOSTANDARD("MIPI_DPHY_DCI"),         // I/O standard
			.SIM_DEVICE("ULTRASCALE_PLUS")  // Set the device version (ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1,
											// ULTRASCALE_PLUS_ES2)
		)
		IBUFDS_DPHY_inst_u0 (
			.HSRX_O(data_in_from_pins_int[i]),             // 1-bit output: HS RX output
			.LPRX_O_N(),         // 1-bit output: LP RX output (Slave)
			.LPRX_O_P(),         // 1-bit output: LP RX output (Master)
			.HSRX_DISABLE(1'b0), // 1-bit input: Disable control for HS mode
			.I(mipi_data_p[i]),                       // 1-bit input: Data input0 PAD
			.IB(mipi_data_n[i]),                     // 1-bit input: Data input1 PAD
			.LPRX_DISABLE(1'b1)  // 1-bit input: Disable control for LP mode
		);
		
		
		ISERDESE3 #(
			.DATA_WIDTH(8),                 // Parallel data width (4,8)
			.FIFO_ENABLE("FALSE"),          // Enables the use of the FIFO
			.FIFO_SYNC_MODE("FALSE"),       // Always set to FALSE. TRUE is reserved for later use.
			.IS_CLK_B_INVERTED(1'b1),       // Optional inversion for CLK_B
			.IS_CLK_INVERTED(1'b0),         // Optional inversion for CLK
			.IS_RST_INVERTED(1'b0),         // Optional inversion for RST
			.SIM_DEVICE("ULTRASCALE_PLUS")  // Set the device version for simulation functionality (ULTRASCALE,
											// ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
		)
		ISERDESE3_u0 (
			.FIFO_EMPTY(),           // 1-bit output: FIFO empty flag
			.INTERNAL_DIVCLK(), // 1-bit output: Internally divided down clock used when FIFO is
												// disabled (do not connect)
		
			.Q(lane_byte_data[i]),                             // 8-bit registered output
			.CLK(clk_in_int),                         // 1-bit input: High-speed clock
			.CLKDIV(clk_div),                   // 1-bit input: Divided Clock
			.CLK_B(clk_in_int),                     // 1-bit input: Inversion of High-speed clock CLK
			.D(data_in_from_pins_int[i]),                             // 1-bit input: Serial Data Input
			.FIFO_RD_CLK(),         // 1-bit input: FIFO read clock
			.FIFO_RD_EN(),           // 1-bit input: Enables reading the FIFO when asserted
			.RST(1'b0)                          // 1-bit input: Asynchronous Reset
		);//set_property DATA_RATE SDR|DDR [get_ports port_name]
	end	

endgenerate





endmodule
