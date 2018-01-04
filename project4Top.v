//////////////////////////////////////////////////////////////////
// Filename: project4Top.v
// Author:   Tom Martin
// Date:     7 November 2017
// Revision: 1
//
// This is the top-level module for ECE 3544 Project 4.
// Do not modify the module declaration or ports in this file.
// Before downloading your design to the DE1-SoC board,
// you MUST make the pin assignments in Quartus using
// the steps described in the lab manual and the pin information
// provided in the DE1-SoC manual.  Failing to make the 
// pin assignments may damage your board.

module project4Top(CLOCK_50, KEY, SW, LED, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input        CLOCK_50;
	input [3:0]  KEY;
	input [9:0]  SW;
	output [9:0] LED;
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	wire adjust_pressed, startstop_pressed, mode_pressed;
	//wire [7:0] hexhr, hexmin;
	wire [3:0] Hd5, Hd4, Hd3, Hd2, Hd1, Hd0;
   wire [6:0]	o_Hex11,o_Hex12,o_Hex21,o_Hex22, o_Hex31, o_Hex32, o_Hex41;
	
	keypressed U1 (.clock(CLOCK_50),.reset(KEY[0]),.enable_in(KEY[1]),
						.enable_out(adjust_pressed));		
	keypressed U2 (.clock(CLOCK_50),.reset(KEY[0]),.enable_in(KEY[2]),
						.enable_out(startstop_pressed));
	keypressed U3 (.clock(CLOCK_50),.reset(KEY[0]),.enable_in(KEY[3]),
						.enable_out(mode_pressed));		

   timer_mary89 U4(.clock(CLOCK_50), .reset(KEY[0]), .adjust(adjust_pressed), 
						 .start_stop(startstop_pressed), .mode(mode_pressed), 
						 .d5(Hd5), .d4(Hd4), .d3(Hd3), .d2(Hd2), .d1(Hd1), .d0(Hd0));

   seven_segment U5(Hd5, o_Hex32);
	seven_segment U6(Hd4, o_Hex31);
	seven_segment U7(Hd3, o_Hex22);
	seven_segment U8(Hd2, o_Hex21);
	seven_segment U9(Hd1, o_Hex12);
	seven_segment Ua(Hd0, o_Hex11);
	

	assign HEX5 = o_Hex32;
	assign HEX4 = o_Hex31;
	assign HEX3 = o_Hex22;
	assign HEX2 = o_Hex21;
	assign HEX1 = o_Hex12;
	assign HEX0 = o_Hex11;

	
	
	
endmodule
