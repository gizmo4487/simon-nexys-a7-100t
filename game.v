`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Maxwell Gorley
// 
// Create Date: 11/16/2021 11:57:19 AM
// Design Name: 
// Module Name: game
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
module game(
    input CLK, BTNU, BTND, BTNL, BTNR, BTNC,
    input [1:0] rand_num,	// Random number from random.v
    output reg LED16_R, LED16_G, LED16_B,
    output reg [31:0] value,	// Score output for 7-segment display
    output reg [15:0] LED,	// Game win LEDs
    output reg [2:0] note=5,	// Stop playing sound
    output reg lose=0	// LOSE on 7-segment display - Blank for now
    );
    reg [2:0] score=0;
    reg [3:0] state=0;
    reg [26:0] delay_timer=0;	// Delay between each color
    reg [26:0] delay_max=100000000;	// Max delay, which changes each round
    reg [15:0] debounce_max=50000;	// Used to avoid input bouncing
    reg [2:0] color_index=0;    // Index
    reg [1:0] color_mem[7:0];	// Memory used to store colors
    
    always @(posedge CLK) begin
        value<=score;	// Update 7-segment display with score
        case(state)
            0: begin    // Press BTNC to start the game
                if(BTNC) begin
                    lose<=0;	// Make LOSE disappear from 7-segment display
                    score<=0;
                    state<=1;
                end
            end
            1: begin
                 LED16_R<=0;	// Turn off RGB LEDs
                 LED16_G<=0;
                 LED16_B<=0;
                 delay_timer<=0;	// Reset delay timer
                 color_mem[score] <= rand_num;   // Store color in memory, then flash lights
                 color_index<=0;	// Start at the first color in memory
                 state<=2;
            end
            2: begin
                if(delay_timer<(delay_max/2)) begin
                    delay_timer<=delay_timer+1;
                    case(color_mem[color_index])
                        0: begin    // Red
                            note<=0;    // Play sound for red
                            LED16_R<=1;
                            LED16_G<=0;
                            LED16_B<=0;
                        end
                        1: begin    // Green
                            note<=1;    // Play sound for green
                            LED16_R<=0;
                            LED16_G<=1;
                            LED16_B<=0;
                        end
                        2: begin    // Blue
                            note<=2;    // Play sound for blue
                            LED16_R<=0;
                            LED16_G<=0;
                            LED16_B<=1;
                        end
                        3: begin    // Yellow
                            note<=3;    // Play sound for yellow
                            LED16_R<=1;
                            LED16_G<=1;
                            LED16_B<=0;
                        end
                    endcase
                end
                else if(delay_timer<delay_max) begin    // Turn light off
                    note<=5;    // Stop playing sound
                    delay_timer<=delay_timer+1;
                    LED16_R<=0;
                    LED16_G<=0;
                    LED16_B<=0;
                end
                else begin
                    delay_timer<=0;
                    if(color_index==score) begin    // Stop when all colors are shown
                        state<=3;
                    end
                    else begin
                        color_index<=color_index+1;
                    end
                end
            end
            3: begin
                if(~BTNC) begin
                    state<=4;
                    color_index<=0;	// Reset index to start checking input
                end
            end
            4: begin    // Check user input
                if(BTNL&&~BTNR&&~BTNU&&~BTND) begin // Red
                    if(delay_timer<debounce_max) begin
                        delay_timer<=delay_timer+1;
                    end
                    else begin
                        delay_timer<=0;
                        if(color_mem[color_index]==0) begin	// Correct
                            state<=5;
                        end
                        else begin	// Incorrect
                            state<=7;
                        end
                    end
                end
                if(BTNR&&~BTNL&&~BTNU&&~BTND) begin // Green
                    if(delay_timer<debounce_max) begin
                        delay_timer<=delay_timer+1;
                    end
                    else begin
                        delay_timer<=0;
                        if(color_mem[color_index]==1) begin	// Correct
                            state<=5;
                        end
                        else begin	// Incorrect
                            state<=7;
                        end
                    end
                end
                if(BTNU&&~BTNL&&~BTNR&&~BTND) begin // Blue
                    if(delay_timer<debounce_max) begin
                        delay_timer<=delay_timer+1;
                    end
                    else begin
                        delay_timer<=0;
                        if(color_mem[color_index]==2) begin	// Correct
                            state<=5;
                        end
                        else begin	// Incorrect
                            state<=7;
                        end
                    end
                end
                if(BTND&&~BTNL&&~BTNR&&~BTNU) begin // Yellow
                    if(delay_timer<debounce_max) begin
                        delay_timer<=delay_timer+1;
                    end
                    else begin
                        delay_timer<=0;
                        if(color_mem[color_index]==3) begin	// Correct
                            state<=5;
                        end
                        else begin	// Incorrect
                            state<=7;
                        end
                    end
                end
                if(~BTNL&&~BTNR&&~BTNU&&~BTND) begin    // Nothing - All lights off
                    delay_timer<=0;
                    LED16_R<=0;
                    LED16_G<=0;
                    LED16_B<=0;
                end
            end
            5: begin    // Player chose the correct color
                if(BTNL&&~BTNR&&~BTNU&&~BTND) begin // Red
                    note<=0;    // Play sound for red
                    LED16_R<=1;
                    LED16_G<=0;
                    LED16_B<=0;
                end
                if(BTNR&&~BTNL&&~BTNU&&~BTND) begin // Green
                    note<=1;    // Play sound for green
                    LED16_R<=0;
                    LED16_G<=1;
                    LED16_B<=0;
                end
                if(BTNU&&~BTNL&&~BTNR&&~BTND) begin // Blue
                    note<=2;    // Play sound for blue
                    LED16_R<=0;
                    LED16_G<=0;
                    LED16_B<=1;
                end
                if(BTND&&~BTNL&&~BTNR&&~BTNU) begin // Yellow
                    note<=3;    // Play sound for yellow
                    LED16_R<=1;
                    LED16_G<=1;
                    LED16_B<=0;
                end
                if(~BTNL&&~BTNR&&~BTNU&&~BTND) begin
                    if(color_index<score) begin // Return to state 4 to check next color
                        note<=5;    // Stop playing sound
                        color_index<=color_index+1;
                        state<=4;
                    end
                    else if(score==5) begin // Player has won
                        note<=5;    // Stop playing sound
                        score<=score+1;
                        LED16_R<=0;
                        LED16_G<=0;
                        LED16_B<=0;
                        state<=8;   // Go to victory state
                    end
                    else begin  // Start the next round
                        note<=5;    // Stop playing sound
                        LED16_R<=0;
                        LED16_G<=0;
                        LED16_B<=0;
                        score<=score+1;
                        state<=6;
                    end
                end
                
            end
            6: begin    // Pause for 1 second, then move to next round
                if(delay_timer<100000000) begin
                    delay_timer<=delay_timer+1;
                end
                else begin
                    delay_max<=delay_max-13333333;  // Make the game faster
                    delay_timer<=0;
                    state<=1;   // Go to the next round
                end
            end
            7: begin    // Incorrect - Game over
                lose<=1;	// Display LOSE on 7-segment display
                delay_max<=100000000;   // Reset speed to default
                note<=4;    // Play game over sound
                LED16_R<=1;	// Show white light
                LED16_G<=1;
                LED16_B<=1;
                if(delay_timer<delay_max) begin
                    delay_timer<=delay_timer+1;
                end
                else begin
                    note<=5;    // Stop playing sound
                    LED16_R<=0;
                    LED16_G<=0;
                    LED16_B<=0;
                    delay_timer<=0;
                    state<=0;	// Go back to the beginning
                end
            end
            8: begin	// Pause before victory sound
                if(delay_timer<40000000) begin
                    delay_timer<=delay_timer+1;
                end
                else begin
                    delay_timer<=0;
                    delay_max<=10000000;	// 0.1 s between notes
                    state<=9;
                    note<=0;
                end
            end
            9: begin	// Victory sound
                if(delay_timer<delay_max) begin
                    delay_timer<=delay_timer+1;
                end
                else begin
                    delay_timer<=0;
                    if(note==2) begin
                        note<=note+1;
                        delay_max<=40000000;	// Hold the last note longer
                    end
                    else if(note==3) begin
                        note<=5;	// Stop playing sound and start light show
                        state<=10;
                    end
                    else begin
                        note<=note+1;
                    end
                end
            end 
            10: begin    // Winner!
                delay_max<=100000000;   // Reset speed to default
                if(BTNC) begin
                    delay_timer<=0;
                    LED<=0;
                    state<=11;		// Return to start after BTNC is released
                end
                else if(delay_timer<(delay_max/2)) begin
                    LED<=16'hffff;	// All LEDs on
                    delay_timer<=delay_timer+1;
                end
                else if(delay_timer<delay_max) begin
                    LED<=0;	// All LEDs off
                    delay_timer<=delay_timer+1;
                end
                else begin
                    delay_timer<=0;
                end
            end
            11: begin
                if(~BTNC) begin
                    state<=0;	// Start over
                end
            end
        endcase
    end
    
endmodule
