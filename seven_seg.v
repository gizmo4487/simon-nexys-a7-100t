`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Maxwell Gorley
// 
// Create Date: 09/16/2021 06:13:42 PM
// Design Name: 
// Module Name: seven_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Made by: Maxwell Gorley
module seven_seg(
     input CLK,
     input [31:0] value,
     input lose,
     output reg [7:0] CA,
     output reg [7:0] AN
    );
    reg [3:0] curVal=0; // Value to display on current anode
    reg [16:0] slow_clk=0;  // Used to refresh displays
    reg [2:0] disp=0;   // Current display
    always @(posedge CLK)
        // Segments to light for each number (DP, G, F, E, D, C, B, A) -- Active low
        begin
            case(curVal)
                0: CA<=8'b11000000;
                1: CA<=8'b11111001;
                2: CA<=8'b10100100;
                3: CA<=8'b10110000;
                4: CA<=8'b10011001;
                5: CA<=8'b10010010;
                6: CA<=8'b10000010;
                7: CA<=8'b11111000;
                8: CA<=8'b10000000;
                9: CA<=8'b10010000;
                10: CA<=8'b10001000;
                11: CA<=8'b10000011;
                12: CA<=8'b10100111;
                13: CA<=8'b10100001;
                14: CA<=8'b10000110;
                15: CA<=8'b11000111;    // L
                default: CA<=8'b01111111;
            endcase
            
       // Switch to new display every 100000 clock ticks, or 1 millisecond
        if(slow_clk==100000)
                begin
                slow_clk<=0;    // Set slow clock back to 0
                // Anode to use for current display -- Active low
                // "disp <= disp+1;" will use the next display when the clock reaches 100000 unless the last display is selected
                // 4 bits of "value" are used to show a hex digit on a single display
                case(disp)
                    0: begin
                        AN<=8'b11111110;
                        curVal<=value[3:0];
                        if(lose) begin
                            disp<=4;
                        end
                        else begin
                            disp<=0;
                        end
                    end
                    1: begin
                        AN<=8'b11111101;
                        curVal<=0;
                        disp<=2;
                    end
                    2: begin
                        AN<=8'b11111011;
                        curVal<=0;
                        disp<=3;
                    end
                    3: begin
                        AN<=8'b11110111;
                        curVal<=0;
                        disp<=4;
                    end
                    4: begin
                        AN<=8'b11101111;
                        curVal<=14;  // E
                        disp<=5;
                    end
                    5: begin
                        AN<=8'b11011111;
                        curVal<=5;  // 5
                        disp<=6;
                    end
                    6: begin
                        AN<=8'b10111111;
                        curVal<=0;   // 0
                        disp<=7;
                    end
                    7: begin
                        AN<=8'b01111111;
                        curVal<=15;   // L
                        disp<=0;
                    end
                endcase
            end
            slow_clk<=slow_clk+1;   // Do 1 tick of the slow clock
        end
endmodule
