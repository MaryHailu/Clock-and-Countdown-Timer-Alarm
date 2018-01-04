////////////////////////////////////////////////////////////////////////////////
// Filename:    timer_mary89.v
// Author:      Mary Hailu
// Date:        11/29/2017
// Version:     1
// Description: Countdown and time-of-day main module .
///////////////////////////////////////////////////////////////////////////////////////////////////
//							      KEY[0] KEY[1]  KEY[2]    KEY[3]
module timer_mary89(clock, reset,adjust, start_stop, mode, d5, d4, d3, d2, d1, d0);
	input         clock, reset, adjust, start_stop, mode;
	output reg [3:0] d5, d4, d3, d2, d1, d0;
	reg [7:0] state;
	reg [3:0] a_0, a_1, a_2, a_3, a_4, a_5;
	reg [3:0] c_0, c_1, c_2, c_3, c_4, c_5, h_0, s_0, s_1;
	reg [3:0] alarm_0, alarm_1, alarm_2, alarm_3, alarm_4, alarm_5, temp_0, temp_1, temp_2;
	reg [3:0] clock_0, clock_1, clock_2, clock_3, clock_4, clock_5;
   reg [26:0] tick, flash;
	wire click, for_flash;
	reg snap;
	parameter s0=0, s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7, s8=8, s9=9;
   parameter s10=10, s11=11, s12=12, s13=13, s14=14, s15=15, s16=16, s17=17, s18=18, s19=19, s20=20;
	/*
	 * This always block will count every seconds 
	*/
	always @(posedge clock or negedge reset)begin
		if(!reset)
			tick <=0;
		else if(tick == 50000000)
			tick <= 0;
		else
			tick <= tick + 1;
	end
	
	/*
	 * This always block will count every half secondes 
	*/
	always @(posedge clock or negedge reset)begin 
		if(!reset)
			flash <=0;
		else if(flash == 25000000)
			flash <= 0;
		else
			flash <= flash + 1;
	end 
	
	assign click = ((tick == 50000000)?1'b1:1'b0);
	assign for_flash = ((flash == 25000000)?1'b1:1'b0);
	

	/*
	 * This always block is a finiet state machin
	 * designed as a main always block it has posedge
	 * clock and negedge reset
	*/
	always @(posedge clock or negedge reset) begin
	
	   if(!reset)begin							//key[0]
		  state <= s0;								//Show ID
		end

		else begin
			case(state)
				s0:state <= s1;					//show time of clock 
				s1:begin
					if(mode)  						//key3
						state <= s2;  				//go to alamr
					else 
						state <= s1;				// start counting 
					end 
				s2:begin     						// alamr
					if(start_stop) 				// key2 
						state <= s3;				// start counting			
					else if(mode)					// key3
						state <= s1;				// go to time of day 
					else if(adjust)				// key1
						state <= s2;				// set and save
					else 
						state <= s2;				// just show th alarm
					end 
				s3: begin							// counting down the alarm
					 if(adjust)   					// key1 -> restet to start value 
						state <= s8;				// reset 
					 else if(start_stop)			// key2 
						state <= s10;				// stop couting
					 else if(mode)					// key3
						state <= s9;				// start counting the time of day
					 else 
						state <= s3;
					 end
				s4: begin 							// flashing hr 
					 if(mode)						// key3	
				   	state <= s5; 				// go to flash min
					 else if(start_stop)			// key2
						state <= s6;            // to increament hr
					 else 
						state <= s4;				// stay flashing hr	
					 end 
				s5: begin
					 if(mode)						// key3
						state <=s4;					// go to flash hr
					 else if(start_stop)			// key2
						state <= s7;				// to increament min
					 else 
						state <= s5;				// stay flashing min
					 end 
				s6: begin							// increamenting hr
					 if(adjust)						// key1
						state <= s8;				// save
					 else 
						state <= s6;
					 end 
			   s7: begin							// increamenting min
						if(adjust)					// key1
							state <= s8;			// save
						else
							state <= s7;			
					 end 
			   s8: begin								// reset the alarm
					  if(adjust)						// key1
					     state <= s4;					// flash hr
					  else if(start_stop)			// start count
						  state <= s18;
					  else 
						  state <=s8;				   // stay on alarm
					  end 
			   s9: begin								// time of clock
				    if(mode)							// key3 go to alarm
						state <= s3;					// 
					 else if(adjust)					// key1 
					   state <= s11;					// flash second
					 else 
						state <= s9;					// stay there
				    end 
				s10:begin								// stop counting													
					 if(start_stop)					// key2
						state <= s3;					// start counting
					 else if(adjust)					// key1
						state <= s8;					// reset
					 else 
						state <= s10;					// stay there
					 end 
				s11:begin
				    if(start_stop)				//key2
					   state <= s12;				// reset second	
					 else 
					   state <= s11;				// stay there
					 end
				s12:begin
					 if(mode)						//key3
						state <= s13;				// go flash min					
					 else 
					   state <= s12;				// stay there
				    end
				s13:begin
					  if(start_stop)				// key2
					    state <= s14;				 //increament clock min
					  else
						 state <= s13;				 // stay there
					 end
				s14:begin
					  if(mode)
						 state <= s15;			    // go flash hr
					  else 
						 state <= s14;				 // stay there
					 end 
			   s15:begin							// hr flashing
					  if(start_stop)
						 state <= s16;				
					  else 
						 state <= s15;
					 end
				s16:begin
					  if(adjust)
						  state <= s17;
					  else 
						  state <= s16;
					 end 
				s17:begin
					 if(mode)
						state <= s3;
					 else 
						state <= s17;
					 end
				s18:begin
					 if(mode)
						state <= s9;
					 else if(start_stop)
					   state <= s19;
					 else 
						state <= s18;
					 end 
				s19:begin
					 if(start_stop)
					   state <= s18;
					 else 
						state <= s19;
					 end
				s20:begin
				     state <= s20;
					 end
			endcase 
	   end
	end
	
	
	/*
	 * This always block set a new value for alarm
	 * it has posedge clock 
	*/
	
	always @(posedge clock)begin
		case(state)
			s0: begin 
				alarm_0 <= 4'd0; alarm_1 <= 4'd0; alarm_2 <= 4'd1;
				alarm_3 <= 4'd0; alarm_4 <= 4'd0; alarm_5 <= 4'ha;	
		   end
			s4:begin
			   if(for_flash)begin // flash every 0.5s
					if(alarm_4 == a_4)
				      alarm_4 <= 4'hb;
			      else 
				      alarm_4 <= a_4;
	       	   end
				end 
			s6: begin
				 if(start_stop)begin
					if(alarm_4 == 4'd0)begin
						alarm_4 <= 4'd9;
					end
					else begin
					  alarm_4 <= alarm_4 + 4'd1;
					end 
				 end 
				 end 
			s7: begin
				 if(start_stop)begin
					if(alarm_2 == 4'd0)begin
						alarm_2 <= 4'd9;
					end
					else begin
						alarm_2 <= alarm_2 + 4'd1;
					end 
				 end
				 end
			s18:begin
				 if(alarm_0 == 4'd0 && alarm_1 == 4'd0 && alarm_2 == 4'd0)begin
					 alarm_0 <= h_0; alarm_1 <= h_0; alarm_2 <= h_0;
				 end 
				 else begin
				 if(click)begin
				   if(alarm_0 == 4'd0)begin
							alarm_0 <= 4'd9;
							if(alarm_1 == 4'd0)begin
							   alarm_1 <= 4'd5;
								if(alarm_2 == 4'd0)begin
								 alarm_2 <= 4'd9;
								end 
								else begin
								 alarm_2 <= alarm_2 - 4'd1;
								end 
							 end
							 else begin
							   alarm_1 <= alarm_1-4'd1;
							 end 
						end
    					else begin
							alarm_0 <= alarm_0 - 4'd1;
						end
			     end 
				 end
			  end 	 
		endcase 
	end 
	
	
	/*
	 * This always block set a new value for clock
	 * it has posedge clock and negedge reset
	*/
	
	always @(posedge clock or negedge reset)begin
	  if(!reset)begin
	    clock_0 <= 4'd0; clock_1 <= 4'd0; clock_2 <= 4'd0;
		 clock_3 <= 4'd0; clock_4 <= 4'd2; clock_5 <= 4'd1;
	  end
	  else begin
		 case(state)
			s14:begin
				  if(start_stop)begin
					  if(clock_2== 4'd9)begin
					     clock_2 <= 4'd0;
						  if(clock_3 == 4'd5)begin
						    clock_3 <= 4'd0;
						  end 
						  else begin
							 clock_3 <= clock_3 + 4'd1;
						  end 
					  end
					  else begin
						  clock_2 <= clock_2 + 4'd1;
					  end  
				  end 
				 end 
			  s16:begin
					if(start_stop)begin
						if(clock_4==4'd2)begin
						   clock_4 <= 4'd0;
							if(clock_5 == 4'd1)begin
								clock_5 <= 4'd0;
							end 
							else begin
								clock_5 <= clock_5 + 4'd1;
						   end 						
						end
						else begin
							clock_4 <= clock_4 + 4'd1;
						end 
					end 
				   end
			  s17:begin
						if(click)begin	
							if(clock_0 == 4'd9)begin
								clock_0 <= 4'd0;
								if(clock_1 == 4'd5)begin
									clock_1 <= 4'd0;
									if(clock_2 == 4'd9)begin
										clock_2 <= 4'd0;
										if(clock_3 == 4'd5)begin
											clock_3 <= 4'd0;
											if(clock_4 == 4'd2)begin
												clock_4 <= 4'd0;
												if(clock_5 == 4'd1)begin
													clock_5 <= 4'd0;
												end 
												else begin
													clock_5 <= clock_5 + 4'd1;
												end
											end
											else begin
												clock_4 <= clock_4 + 4'd1;
											end 
										end 
										else begin
											clock_3 <= clock_3 + 4'd1;
										end
									end
									else begin
										clock_2 <= clock_2 + 4'd1;
									end
									
								 end 
								 else begin
									 clock_1 <= clock_1 + 4'd1;
								 end 
							end
									
							else begin
								clock_0 <= clock_0 + 4'd1;
						   end			  
					 end
			      end
		 endcase 
		end 
	end 
	
	

	
	/*
	 * This always block increament the value for the alarm
	 * it has posedge clock and negedge reset
	*/
	
	always @(posedge clock or negedge reset) begin	
	  if(!reset)begin
			a_0 <= 4'd0; a_1 <= 4'd0; a_2 <= 4'd1; a_3 <= 4'd0;
			a_4 <= 4'd0; a_5 <= 4'd0;
	  end
	  else begin
	    case(state)
			s3:begin
				if(click)begin
					if(a_2== 4'd1)begin
					   a_2 <= 4'd0;
					end 
					if(a_0 == 4'd0)begin
							a_0 <= 4'd9;
							if(a_1 == 4'd0)begin
							   a_1 <= 4'd5;
							 end 
							 else begin
							   a_1 <= a_1-4'd1;
							 end 
						end
    					else begin
							a_0 <= a_0 - 4'd1;
						end
			     end 
			 end
		  endcase 
		end
	 end
	 
	 
	 /*
	 * This always block increament the clock time
	 * it has posedge clock and negedge reset
	*/

	 always @(posedge clock or negedge reset) begin
	  if(!reset)begin
			c_0 <= 4'd0; c_1 <= 4'd0; c_2 <= 4'd0; c_3 <= 4'd0;
			c_4 <= 4'd2; c_5 <= 4'd1;
	  end
	  else begin
		 if(click)begin	
			if(c_0 == 4'd9)begin
				c_0 <= 4'd0;
				if(c_1 == 4'd5)begin
					c_1 <= 4'd0;
					if(c_2 == 4'd9)begin
					   c_2 <= 4'd0;
						if(c_3 == 4'd5)begin
							c_3 <= 4'd0;
							if(c_4 == 4'd2)begin
							   c_4 <= 4'd0;
								if(c_5 == 4'd1)begin
									c_5 <= 4'd0;
								end 
								else begin
								   c_5 <= c_5 + 4'd1;
								end
							end
							else begin
							   c_4 <= c_4 + 4'd1;
							end 
						end 
						else begin
						   c_3 <= c_3 + 4'd1;
						end
					end
					else begin
					   c_2 <= c_2 + 4'd1;
					end
					
				 end 
				 else begin
					 c_1 <= c_1 + 4'd1;
				 end 
			end
					
			else begin
				c_0 <= c_0 + 4'd1;
			end			  
		 end
	  end
	 end 
	

	
	/*
	 * This always block is used to flash the alarm
	 * it has posedge clock
	*/
	always @(posedge clock) begin
	   if(for_flash)begin // flash every 0.5s
		   if(h_0 == 4'd0)
				  h_0 <= 4'hb;
			 else 
				  h_0 <= 4'd0;
		end
	end
	
	
	
	/*
	 * This always block is a finiet state machine
	 * it has posedge clock and negedge reset
	*/
	
	always @(state or start_stop or adjust)begin
		case(state)
			s0:begin // show ID
			   d0 = 4'h8; d1 = 4'h8;
				d2 = 4'h8; d3 = 4'h3;
				d4 = 4'hb; d5 = 4'hb;
			end
			s1:begin //display time of day
				d0 = clock_0; d1 = clock_1;
				d2 = clock_2; d3 = clock_3;
				d4 = clock_4; d5 = clock_5;
			end 
			s2:begin  //display alarm time
				d0 = 4'd0; d1 = 4'd0;
			   d2 = 4'd1; d3 = 4'd0;
			   d4 = 4'd0; d5 = alarm_5;
			end
			s3:begin  // count down alarm
				d0 = a_0;  d1 = a_1;
				d2 = a_2;  d3 = a_3;
				d4 = a_4;  d5 = alarm_5;
			end
			s4:begin 			// flash hr 
				d0 = alarm_0; d1 = alarm_1;
				d2 = alarm_2; d3 = alarm_3;
				d4 = h_0;     d5 = alarm_5;
			end
			s5:begin 			// flash min
				d0 = alarm_0;  d1 = alarm_1;
				d2 = h_0;      d3 = h_0;
				d4 = a_4;  d5 = alarm_5;
			end 
			s6:begin				//increament hr
				d0 = alarm_0;  d1 = alarm_1;
				d2 = alarm_2;  d3 = alarm_3;
				d4 = alarm_4;  d5 = alarm_5;	
			end 
			s7:begin				// increment min 
				d0 = alarm_0;  d1 = alarm_1;
				d2 = alarm_2;  d3 = alarm_3;
				d4 = a_4;  d5 = alarm_5;
			   end 
			s8:begin
				d0 = alarm_0; d1 = alarm_1;
			   d2 = alarm_2; d3 = alarm_3;
			   d4 = a_4; d5 = alarm_5;
				end 
			////////////////////////////////////// clock time
			s9:begin
				d0 = c_0;     d1 = c_1;
			   d2 = c_2; 	  d3 = c_3;
			   d4 = c_4;     d5 = c_5;
				end 
			s11:begin // key1
				d0 = h_0; d1 = h_0;
				d2 = c_2; d3 = c_3;
				d4 = c_4; d5 = c_5;
				end
			s12:begin // key2
				 d0 = clock_0; d1 = clock_1;
				 d2 = c_2; d3 = c_3;
				 d4 = c_4; d5 = c_5;
				 end
			s13:begin
			    d0 = c_0; d1 = c_1;
				 d2 = h_0; d3 = h_0;
				 d4 = c_4; d5 = c_5;
				 end
			s14:begin
			    d0 = c_0; d1 = c_1;
				 d2 = clock_2; d3 = clock_3;
				 d4 = c_4; d5 = c_5;	 
				 end
			s15:begin
				 d0 = c_0; d1 = c_1;
				 d2 = c_2; d3 = c_3;
				 d4 = h_0; d5 = h_0;			
				 end	
         s16:begin
				 d0 = c_0; d1 = c_1;
				 d2 = c_2; d3 = c_3;
				 d4 = c_4; d5 = c_5;	
				 end
			s17:begin
			    d0 = clock_0; d1 = clock_1;
				 d2 = clock_2; d3 = clock_3;
				 d4 = clock_4; d5 = clock_5;	
				 end
			s18:begin
				 d0 = alarm_0; d1 = alarm_1;
				 d2 = alarm_2; d3 = alarm_3;
				 d4 = a_4;     d5 = alarm_5;
				 end 
		   s20:begin
			    d0 = h_0; d1 = h_0;
				 d2 = h_0; d3 = h_0;
				 d4 = h_0; d5 = alarm_5;
				 end
		endcase 		
	end 	
endmodule
