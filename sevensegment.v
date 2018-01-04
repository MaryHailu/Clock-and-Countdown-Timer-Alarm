////////////////////////////////////////////////////////////////////////////////
// Filename:    seven_segment.v
// Author:      Mary
// Date:        11 Nov 2017
// Version:     1
// Description: A 16-bit synchronous FSM.
///////////////////////////////////////////////////////////////////////////////////////////////////
module seven_segment(in, out);											// module start here 
	
	input  [3:0] in;															// 4-bit input
	output reg [6:0] out;													// 7-bit output
       
		 always @ (in) begin												   // always block begin here
            case(in)
	 
                  4'b0000: out = 7'b1000000;							
						4'b0001: out = 7'b1111001;
						4'b0010: out = 7'b0100100;
						4'b0011: out = 7'b0110000;
						4'b0100: out = 7'b0011001;
                  4'b0101: out = 7'b0010010;
						4'b0110: out = 7'b0000010;
                  4'b0111: out = 7'b1111000;
						4'b1000: out = 7'b0000000;
						4'b1001: out = 7'b0010000;
						4'b1010: out = 7'b0001000; 
						4'b1011: out = 7'b1111111;
						default : out = 7'bxxxxxxx;
	 endcase																		// always block end here 
	 end
endmodule
