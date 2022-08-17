`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maxwell Gorley
// 
// Create Date: 12/03/2021 01:39:37 PM
// Design Name: 
// Module Name: sound
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


module sound(
    input CLK,
    input [2:0] note,
    output reg AUD_PWM,
    output reg AUD_SD
    );
    reg [26:0] period=0;
    reg [26:0] counter=0;
    reg [26:0] death_timer; // Note timer for Mario death sound
    reg [9:0] death_timer_mod=381; // Used to simulate modulus to increase period for each note in the Mario death sound
    reg [9:0] death_timer_current;
    reg [1:0] death_count;  // Current note in the Mario death sound
    always @(posedge CLK) begin
        case(note)
            0: begin    // C4 - Red
                //period<=382219; *Period is divided by 2 beforehand to avoid timing violations
                period<=191109;
            end
            1: begin    // E4 - Green
                //period<=303370;
                period<=151685;
            end
            2: begin    // G4 - Blue
                //period<=255102;
                period<=127551;
            end
            3: begin    // C5 - Yellow
                //period<=191113;
                period<=95556;
            end
            4: begin    // Mario death sound - Game over
                if(death_timer==0&&death_count==0) begin
                    period<=107259; // Start at Bb4
                    death_timer_mod<=381;	// Every 381 ticks, add 1 to the period so the note reaches A#4 in 0.05 seconds
                end
                if(death_timer<5000000) begin	// Change notes every 0.05 seconds
                    death_timer<=death_timer+1;
                    death_timer_current<=death_timer_current+1;
                    if(death_timer_current==death_timer_mod) begin
                        period<=period+1;
                        death_timer_current<=0;
                    end
                end
                else begin
                    case(death_count)
                        0: begin
                            death_timer<=0;
                            death_timer_current<=0;
                            death_count<=death_count+1;
                            death_timer_mod<=403;	// Every 403 ticks, add 1 to the period so the note reaches A4 in 0.05 seconds
                            period<=101239; // Start at B4
                        end
                        1: begin
                            death_timer<=0;
                            death_timer_current<=0;
                            death_count<=death_count+1;
                            death_timer_mod<=322;	// Every 322 ticks, add 1 to the period so the note reach Bb4 in 0.05 seconds.
                            period<=94713;  // Start between C5 and C#5
                        end
                        2: begin
                            death_timer_current<=0;
                            period<=0;  // Silent
                        end
                    endcase
                end
            end
            5: begin    // Silent
                period<=0;
                death_timer<=0;
                death_timer_current<=0;
                death_count<=0;
            end
        endcase
        
        if(period==0) begin	// Period of 0 = Stop playing
            AUD_SD<=0;
            AUD_PWM<=0;
        end
        
        else begin
            AUD_SD<=1;
            if(counter<period) begin
                counter<=counter+1;
            end
            else begin
                counter<=0;
                AUD_PWM<=~AUD_PWM;
            end
        end
    end
endmodule
