//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/12/28     meisq          1.0         Original
//*******************************************************************************/

module lut_ov5640(
	input[9:0]             lut_index, // Look-up table index address
	output reg[31:0]       lut_data   // I2C device address register address register data
);

always@(*)
begin
	case(lut_index)
		//                                ID    REG_ADDR  REG_VAL
		  0: lut_data  <=       {8'h78, 16'h3103, 8'h11};
		  1: lut_data  <=       {8'h78, 16'h3008, 8'h82};
		  2: lut_data  <=       {8'h78, 16'h3008, 8'h42};
		  3: lut_data  <=       {8'h78, 16'h3103, 8'h03};
		  4: lut_data  <=       {8'h78, 16'h3017, 8'h00};
		  5: lut_data  <=       {8'h78, 16'h3018, 8'h00};
		  6: lut_data  <=       {8'h78, 16'h3034, 8'h18};
		  7: lut_data  <=       {8'h78, 16'h3035, 8'h11};       // PLL root divider, bit[4], PLL pre-divider, bit[3:0]
		  8: lut_data  <=       {8'h78, 16'h3036, 8'h38};       // PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2] // SCLK root divider, bit[1:0] 
		  9: lut_data  <=       {8'h78, 16'h3037, 8'h11};
		 10: lut_data  <=       {8'h78, 16'h3108, 8'h01};
		 11: lut_data  <=       {8'h78, 16'h303D, 8'h10};
		 12: lut_data  <=       {8'h78, 16'h303B, 8'h19};
		 13: lut_data  <=       {8'h78, 16'h3630, 8'h2e};
		 14: lut_data  <=       {8'h78, 16'h3631, 8'h0e};
		 15: lut_data  <=       {8'h78, 16'h3632, 8'he2};
		 16: lut_data  <=       {8'h78, 16'h3633, 8'h23};
		 17: lut_data  <=       {8'h78, 16'h3621, 8'he0};
		 18: lut_data  <=       {8'h78, 16'h3704, 8'ha0};
		 19: lut_data  <=       {8'h78, 16'h3703, 8'h5a};
		 20: lut_data  <=       {8'h78, 16'h3715, 8'h78};
		 21: lut_data  <=       {8'h78, 16'h3717, 8'h01};
		 22: lut_data  <=       {8'h78, 16'h370b, 8'h60};
		 23: lut_data  <=       {8'h78, 16'h3705, 8'h1a};
		 24: lut_data  <=       {8'h78, 16'h3905, 8'h02};
		 25: lut_data  <=       {8'h78, 16'h3906, 8'h10};
		 26: lut_data  <=       {8'h78, 16'h3901, 8'h0a};
		 27: lut_data  <=       {8'h78, 16'h3731, 8'h02};
		 28: lut_data  <=       {8'h78, 16'h3600, 8'h37};
		 29: lut_data  <=       {8'h78, 16'h3601, 8'h33};
		 30: lut_data  <=       {8'h78, 16'h302d, 8'h60};
		 31: lut_data  <=       {8'h78, 16'h3620, 8'h52};
		 32: lut_data  <=       {8'h78, 16'h371b, 8'h20};
		 33: lut_data  <=       {8'h78, 16'h471c, 8'h50};
		 34: lut_data  <=       {8'h78, 16'h3a13, 8'h43};
		 35: lut_data  <=       {8'h78, 16'h3a18, 8'h00};
		 36: lut_data  <=       {8'h78, 16'h3a19, 8'hf8};
		 37: lut_data  <=       {8'h78, 16'h3635, 8'h13};
		 38: lut_data  <=       {8'h78, 16'h3636, 8'h06};
		 39: lut_data  <=       {8'h78, 16'h3634, 8'h44};     
		 40: lut_data  <=       {8'h78, 16'h3622, 8'h01};
		 41: lut_data  <=       {8'h78, 16'h3c01, 8'h34};
		 42: lut_data  <=       {8'h78, 16'h3c04, 8'h28};
		 43: lut_data  <=       {8'h78, 16'h3c05, 8'h98};
		 44: lut_data  <=       {8'h78, 16'h3c06, 8'h00};
		 45: lut_data  <=       {8'h78, 16'h3c07, 8'h08};
		 46: lut_data  <=       {8'h78, 16'h3c08, 8'h00};
		 47: lut_data  <=       {8'h78, 16'h3c09, 8'h1c};
		 48: lut_data  <=       {8'h78, 16'h3c0a, 8'h9c};
		 49: lut_data  <=       {8'h78, 16'h3c0b, 8'h40};
		 50: lut_data  <=       {8'h78, 16'h503d, 8'h00};//正常 00  八彩条测试：80
		 51: lut_data  <=       {8'h78, 16'h3820, 8'h46};
		 52: lut_data  <=       {8'h78, 16'h300e, 8'h45};
		 53: lut_data  <=       {8'h78, 16'h4800, 8'h14};
		 54: lut_data  <=       {8'h78, 16'h302e, 8'h08};
		 55: lut_data  <=       {8'h78, 16'h4300, 8'h6f};
		 56: lut_data  <=       {8'h78, 16'h501f, 8'h01};
		 57: lut_data  <=       {8'h78, 16'h4713, 8'h03};
		 58: lut_data  <=       {8'h78, 16'h4407, 8'h04};
		 59: lut_data  <=       {8'h78, 16'h440e, 8'h00};    
		 60: lut_data  <=       {8'h78, 16'h460b, 8'h35};
		 61: lut_data  <=       {8'h78, 16'h460c, 8'h20};
		 62: lut_data  <=       {8'h78, 16'h3824, 8'h01};
		 63: lut_data  <=       {8'h78, 16'h5000, 8'h07};
		 64: lut_data  <=       {8'h78, 16'h5001, 8'h03};
		 65: lut_data  <=       {8'h78, 16'h3008, 8'h42};
		 66: lut_data  <=       {8'h78, 16'h3035, 8'h21};
		 67: lut_data  <=       {8'h78, 16'h3036, 8'h69};//0X46=======70     ===0x69========105
		 68: lut_data  <=       {8'h78, 16'h3037, 8'h05};
		 69: lut_data  <=       {8'h78, 16'h3108, 8'h11};  
		 70: lut_data  <=       {8'h78, 16'h3034, 8'h1A};
		 71: lut_data  <=       {8'h78, 16'h3800, 8'h01}; // X address start high byte
		 72: lut_data  <=       {8'h78, 16'h3801, 8'h50}; // X address start low byte
		 73: lut_data  <=       {8'h78, 16'h3802, 8'h01}; // Y address start high byte
		 74: lut_data  <=       {8'h78, 16'h3803, 8'hAA};
		 75: lut_data  <=       {8'h78, 16'h3804, 8'h08}; // 
		 76: lut_data  <=       {8'h78, 16'h3805, 8'hEF}; // 
		 77: lut_data  <=       {8'h78, 16'h3806, 8'h05};
		 78: lut_data  <=       {8'h78, 16'h3807, 8'hF9};
		 79: lut_data  <=       {8'h78, 16'h3810, 8'h00};    
		 80: lut_data  <=       {8'h78, 16'h3811, 8'h10}; // 
		 81: lut_data  <=       {8'h78, 16'h3812, 8'h00};
		 82: lut_data  <=       {8'h78, 16'h3813, 8'h0C};
		 83: lut_data  <=       {8'h78, 16'h3808, 8'h07};       // X_OUTPUT_SIZE:16'h0520 -> 1280
		 84: lut_data  <=       {8'h78, 16'h3809, 8'h80};       
		 85: lut_data  <=       {8'h78, 16'h380a, 8'h04};       // Y_OUTPUT_SIZE:16'h02d0 -> 720
		 86: lut_data  <=       {8'h78, 16'h380b, 8'h38};       
		 87: lut_data  <=       {8'h78, 16'h380c, 8'h09};
		 88: lut_data  <=       {8'h78, 16'h380d, 8'hC4};
		 89: lut_data  <=       {8'h78, 16'h380e, 8'h04};  
		 90: lut_data  <=       {8'h78, 16'h380f, 8'h60};
		 91: lut_data  <=       {8'h78, 16'h3814, 8'h11};
		 92: lut_data  <=       {8'h78, 16'h3815, 8'h11};
		 93: lut_data  <=       {8'h78, 16'h3821, 8'h00};
		 94: lut_data  <=       {8'h78, 16'h4837, 8'h24};
		 95: lut_data  <=       {8'h78, 16'h3618, 8'h00};
		 96: lut_data  <=       {8'h78, 16'h3612, 8'h59};
		 97: lut_data  <=       {8'h78, 16'h3708, 8'h64};
		 98: lut_data  <=       {8'h78, 16'h3709, 8'h52};
		 99: lut_data  <=       {8'h78, 16'h370c, 8'h03};     
		100: lut_data  <=       {8'h78, 16'h4300, 8'h00}; // Formatter RAW, [3:0]=0x0 BGBG/GRGR
		101: lut_data  <=       {8'h78, 16'h501f, 8'h03}; // Format select ISP RAW (DPC)
		102: lut_data  <=       {8'h78, 16'h3406, 8'h00};
		103: lut_data  <=       {8'h78, 16'h5192, 8'h04};
		104: lut_data  <=       {8'h78, 16'h5191, 8'hf8};
		105: lut_data  <=       {8'h78, 16'h518d, 8'h26};
		106: lut_data  <=       {8'h78, 16'h518f, 8'h42};
		107: lut_data  <=       {8'h78, 16'h518e, 8'h2b};
		108: lut_data  <=       {8'h78, 16'h5190, 8'h42};
		109: lut_data  <=       {8'h78, 16'h518b, 8'hd0};       
		110: lut_data  <=       {8'h78, 16'h518c, 8'hbd};
		111: lut_data  <=       {8'h78, 16'h5187, 8'h18};
		112: lut_data  <=       {8'h78, 16'h5188, 8'h18};
		113: lut_data  <=       {8'h78, 16'h5189, 8'h56};
		114: lut_data  <=       {8'h78, 16'h518a, 8'h5c};
		115: lut_data  <=       {8'h78, 16'h5186, 8'h1c};
		116: lut_data  <=       {8'h78, 16'h5181, 8'h50};
		117: lut_data  <=       {8'h78, 16'h5184, 8'h20};
		118: lut_data  <=       {8'h78, 16'h5182, 8'h11};
		119: lut_data  <=       {8'h78, 16'h5183, 8'h00};        
		120: lut_data  <=       {8'h78, 16'h5001, 8'h03};
		121: lut_data  <=       {8'h78, 16'h3008, 8'h02};
		
		default:lut_data <= {8'hff,16'hffff,8'hff};
	endcase
end


endmodule 