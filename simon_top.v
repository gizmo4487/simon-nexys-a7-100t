`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Maxwell Gorley
// 
// Create Date: 11/16/2021 11:35:32 AM
// Design Name: 
// Module Name: simon_top
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
// Created by Maxwell Gorley

module simon_top(
    input CLK, BTNU, BTND, BTNL, BTNR, BTNC,
    output [7:0] AN,CA,
    output [15:0] LED,	// Victory LEDs
    output LED16_R, LED16_G, LED16_B, AUD_SD, AUD_PWM	// RGB LEDs and audio output
    );
    wire [31:0] value;	// 7-segment display output (score)
    wire [1:0] rand_num;	// Gets random color from random.v
    wire [2:0] note;	// Used to play sound when a button is pressed
    wire lose;	// Used to display LOSE on 7-segment display
    
    random RNG(.CLK(CLK),.rand_num(rand_num));
    game simon(.CLK(CLK),.BTNU(BTNU),.BTND(BTND),.BTNL(BTNL),.BTNR(BTNR),.BTNC(BTNC),.rand_num(rand_num),.LED16_R(LED16_R),.LED16_G(LED16_G),.LED16_B(LED16_B),.value(value),.LED(LED),.note(note),.lose(lose));
    seven_seg seven_seg(.CLK(CLK),.AN(AN),.CA(CA),.value(value),.lose(lose));
    sound sound(.CLK(CLK),.note(note),.AUD_SD(AUD_SD),.AUD_PWM(AUD_PWM));
endmodule
