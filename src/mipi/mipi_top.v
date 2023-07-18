module mipi_top(

	input					resetn	,
	input					clk_400m,
	// MIPI
    input                   mipi_clk_p              ,
    input                   mipi_clk_n              ,
    input           [ 1:0]  mipi_data_p             ,
    input           [ 1:0]  mipi_data_n             ,
	// 
    output  wire            pixel_clk               ,
    output  wire            pixel_vld               ,       
    output  wire    [39:0]  pixel_data     // {P1, P2, P3, P4} 
);


//============define=========

wire [7:0]	lane0_byte_data;
wire		lane0_byte_vld;
wire [7:0]	lane1_byte_data;
wire		lane1_byte_vld;


wire [15:0]	word_data		;
wire 		word_vld		;
wire 		invalid_start	;

wire 		mipi_byte_clk;
wire [7:0]	lane0_data  ; 
wire [7:0]	lane1_data  ; 

wire                         raw_vld                         ; 
wire [15:0]                  raw_data                        ;

wire raw_vsync;
wire packet_done;
//==============main code=============

assign pixel_clk = mipi_byte_clk;

//===========

// mipi_phy_gen       mipi_phy_inst(
        // // 
        // .resetn                 (resetn                ),
        // //
        // .mipi_clk_p             (mipi_clk_p             ),
        // .mipi_clk_n             (mipi_clk_n             ),
        // .mipi_data_p            (mipi_data_p            ),
        // .mipi_data_n            (mipi_data_n            ),
        // // 
        // .mipi_byte_clk          (	mipi_byte_clk         ),
        // .lane0_byte_data        (   lane0_data     		),
        // .lane1_byte_data        (	lane1_data        )
// );

mipi_phy_gen_idelay       mipi_phy_inst(
        // 
        .resetn                 (resetn                ),
		.clk_400m				(clk_400m				),
        //
        .mipi_clk_p             (mipi_clk_p             ),
        .mipi_clk_n             (mipi_clk_n             ),
        .mipi_data_p            (mipi_data_p            ),
        .mipi_data_n            (mipi_data_n            ),
        // 
        .mipi_byte_clk          (	mipi_byte_clk         ),
        .lane0_byte_data        (   lane0_data     		),
        .lane1_byte_data        (	lane1_data        )
);

//=========main code===========
byte_align byte_align_inst0(
	.clk			(mipi_byte_clk			)	,
	.resetn			(resetn			),
	.lane_data		(lane0_data		),
	.mipi_byte_data	(lane0_byte_data),
	.mipi_byte_vld  (lane0_byte_vld)	,
	.re_find        (invalid_start | packet_done       )
); 

byte_align byte_align_inst1(
	.clk			(mipi_byte_clk			)	,
	.resetn			(resetn			),
	.lane_data		(lane1_data		),
	.mipi_byte_data	(lane1_byte_data),
	.mipi_byte_vld  (lane1_byte_vld)	,
	.re_find        (invalid_start | packet_done)
); 


lane_align lane_align_inst(
	.clk				(mipi_byte_clk				),
	.resetn				(resetn				),
	.lane0_byte_data    (lane0_byte_data    ),
	.lane1_byte_data    (lane1_byte_data    ),
	.lane0_byte_vld     (lane0_byte_vld     ),
	.lane1_byte_vld     (lane1_byte_vld     ),
	.word_data			(word_data			),
	.word_vld			(word_vld			),
	.invalid_start		(invalid_start		),
	.packet_done		(packet_done)
);

 

packet_handler packet_handler_inst( 
	
	.clk		(mipi_byte_clk		)	,
	.resetn		(resetn		),
	.word_data	(word_data	),
	.word_vld	(word_vld	),
	.raw_vld	(raw_vld	)	,
	.raw_data	(raw_data	),
	.raw_vsync	(raw_vsync	),
	.packet_done(packet_done)	
);


byte2pixel      byte2pixel_inst(
        // system signals
        .clk                   (mipi_byte_clk          ),
        .resetn                (resetn                ),
        // RAW Data
        .raw_vld                (raw_vld                ),
        .raw_data               (raw_data               ),
        .raw_vsync              (raw_vsync              ),
        // Pixel Data
        .pixel_vld              (pixel_vld              ),
        .pixel_data             (pixel_data             )
);

// mipi_check mipi_check_inst(
	// .clk			(mipi_byte_clk			)	,
	// .resetn			(resetn			)	,
					
	// .raw_vld		(raw_vld		)	,
	// .raw_data		(raw_data		)	,
	// .raw_vsync		(raw_vsync		)	,
					
	// .lane0_data		(lane0_data		),
	// .lane1_data		(lane1_data		),
	// .lane0_byte_data(lane0_byte_data),
	// .lane0_byte_vld (lane0_byte_vld ),
	// .lane1_byte_data(lane1_byte_data),
	// .lane1_byte_vld	(lane1_byte_vld	),
	// .word_data		(word_data		),
	// .word_vld		(word_vld		),
	// .invalid_start	(invalid_start	),
	// .packet_done    (packet_done    )

	

// );
endmodule