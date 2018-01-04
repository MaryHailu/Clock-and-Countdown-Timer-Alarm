////////////////////////////////////////////////////////////////////////////////
// Filename:    tb_timer.v
// Author:      Mary
// Date:        11/29/2017
// Version:     1
// Description: timer testbench.

//`timescale 1 ns/100 ps

module tb_timer_mary89();
	reg         clock, reset, adjust, start_stop, mode;
	wire [3:0]  d5, d4, d3, d2, d1, d0;

// Instantiate main module .

	timer_mary89 DUT(clock, reset,adjust, start_stop, mode, d5, d4, d3, d2, d1, d0);	

// Test the counter functionality here.
// You should set up a 50 MHz clock, along with the various control and input signals.

   initial begin

   clock = 1'b0;
   reset = 1'b0;
	#25;

	clock = 1'b1;
	reset = 1'b0;
	adjust = 1'b0;
	start_stop = 1'b0;
	mode = 1'b0;
	#25;

   clock = 1'b0;
	reset = 1'b1;
	#25; 

	clock = 1'b1;
	reset = 1'b0;
	adjust = 1'b0;
	start_stop = 1'b0;
	mode = 1'b1;
	#25;
	
	clock = 1'b0;
	reset = 1'b1;
	#25;

   clock = 1'b1;
	reset = 1'b1;
	adjust = 1'b0;
	start_stop = 1'b0;
	mode = 1'b0;
	#25; 
	
	clock = 1'b0;
	reset = 1'b1;
	#25;

   clock = 1'b1;
	reset = 1'b1;
	adjust = 1'b0;
	start_stop = 1'b0;
	mode = 1'b1;
	#25;

   clock = 1'b0;
	reset = 1'b1;
	#25;

   clock = 1'b1;
	reset = 1'b1;
	adjust = 1'b0;
	start_stop = 1'b0;
	mode = 1'b0;
	#25; 	
	
	end 

endmodule 
