`timescale 1ns / 1ps

module dancing_segment(
    input clk,
    input clr,
    input BNTR,
     input BNTL, 
     input BNTC,       
    output reg [6:0] a_to_g,
    output wire [3:0] an,
    output wire dp 
);
reg  [30:0] clkdiv;	 	 
wire [2:0] state= clkdiv[30:28]; 
reg  [3:0] digit;
reg [2:0] rotation=3'b010;
reg flag=0;
assign dp = 1;			 
assign an = 4'b1110; 

always @(posedge clk) begin
 if(BNTL)
 begin
     rotation=2'b00;
 end
 if(BNTR)
 begin
     rotation=2'b01;
 end
 if(BNTC)
 begin
     rotation=2'b10;
  end
end

always @(*)
begin
   if(rotation==0)
    begin
         case(state)
         //////////<---MSB-LSB<---
         //////////////gfedcba//////////////                                        
         0:a_to_g = 7'b0111111;                                                                 
         1:a_to_g = 7'b0011101;                                               
         2:a_to_g = 7'b0011110;                                                               
         3:a_to_g = 7'b1011100;                                           
         4:a_to_g = 7'b0111100;                                                       
         default: a_to_g = 7'b1111111;
         endcase
  
    end

   else if(rotation==1)
    begin
      a_to_g = 7'b0111111;
    
       case(state)
       
       //////////<---MSB-LSB<---
       //////////////gfedcba////////////////                                          
       0:a_to_g = 7'b0111111;                                                         
       1:a_to_g = 7'b0011101;                                                 
       2:a_to_g = 7'b0111100;                                                  
       3:a_to_g = 7'b1011100;                                                 
       4:a_to_g = 7'b0011110;                                     
       
       default: a_to_g = 7'b1111111; ///
       endcase
    
   end

   else if(rotation==2)
    begin
       case(digit)
       
       //////////<---MSB-LSB<---
       //////////////gfedcba///////////////   
       0:a_to_g = 7'b0111111;                                                              
       1:a_to_g = 7'b0111111;                                             
       2:a_to_g = 7'b0111111;                                                  
       //                                                              
       3:a_to_g = 7'b0111111;                                                       
       4:a_to_g = 7'b0111111;                                          
       
       default: a_to_g = 7'b1111111; 
   endcase
   end
end


always @(posedge clk) begin
if ( clr == 1)
begin
	clkdiv <= 0;
end
else
if(flag==0)
	clkdiv <= clkdiv+2;
else
	clkdiv <= clkdiv+4;    	
	
if(state==5)
    begin
	clkdiv[30:0]<=31'b0010000000000000000000000000000;
	flag<=1;
	end
if(BNTL==1||BNTC==1||BNTR==1)
begin
        clkdiv<=0;
        flag<=0;
 end
end


endmodule
