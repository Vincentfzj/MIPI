module byte_align(
	input			clk				,
	input			resetn			,
	input	[7:0]	lane_data		,
	output reg[7:0]	mipi_byte_data	,
	output reg		mipi_byte_vld  	,
	input			re_find
);  

//================define==========
localparam SYNC  = 8'hb8;
reg [2:0]	offset;

reg [7:0]	lane_data_r1;


wire [15:0]	data_16bit;
reg [15:0]	data_16bit_r1;

//===================main code=====
always@(posedge clk)begin
	lane_data_r1 <= lane_data;
	data_16bit_r1<= data_16bit;
end

assign data_16bit = {lane_data,lane_data_r1};

always@(posedge clk or negedge resetn)begin
	if(!resetn)begin
		offset <= 'd0;
		mipi_byte_vld <= 1'b0;
	end
	else if(re_find)begin
		offset <= 'd0;
		mipi_byte_vld <= 1'b0;
	end
	else if(mipi_byte_vld == 1'b0)begin
		if(data_16bit[7:0] == SYNC)begin
			offset <= 'd0;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[8:1] == SYNC)begin
			offset <= 'd1;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[9:2] == SYNC)begin
			offset <= 'd2;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[10:3] == SYNC)begin
			offset <= 'd3;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[11:4] == SYNC)begin
			offset <= 'd4;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[12:5] == SYNC)begin
			offset <= 'd5;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[13:6] == SYNC)begin
			offset <= 'd6;
			mipi_byte_vld <= 1'b1;
		end
		else if(data_16bit[14:7] == SYNC)begin
			offset <= 'd7;
			mipi_byte_vld <= 1'b1;
		end
	end
end

//assign mipi_byte_data data_16bit_r1[offset+7:offset];]
always@(*)begin
	case(offset)
		0:	mipi_byte_data = data_16bit_r1[7:0];
		1:	mipi_byte_data = data_16bit_r1[8:1];
		2:	mipi_byte_data = data_16bit_r1[9:2];
		3:	mipi_byte_data = data_16bit_r1[10:3];
		4:	mipi_byte_data = data_16bit_r1[11:4];
		5:	mipi_byte_data = data_16bit_r1[12:5];
		6:	mipi_byte_data = data_16bit_r1[13:6];
		7:	mipi_byte_data = data_16bit_r1[14:7];
		default:	mipi_byte_data = data_16bit_r1[7:0];
	endcase
end

endmodule