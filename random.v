`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Maxwell Gorley
// 
// Create Date: 11/16/2021 11:51:36 AM
// Design Name: 
// Module Name: random
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

module random(
    input CLK,
    output reg [1:0] rand_num
    );
    always @(posedge CLK) begin
        rand_num <= rand_num+1;	// Generate random color for Simon game
    end
endmodule
