`timescale 1ns / 1ps

module kypad_decoder(
    input clk,
    input rst,
    output logic [3:0] col,
    input [3:0] row,
    output [3:0] decode_out,
    output is_a_key_pressed
    );
    
     // reach 100_000th clock cyle => pull-down (i.e., logic 0) a column, then increment counter by 1 => read the row, then pull down the row => wait for 8 clock cycles (0.002 period) i.e., 100_008th clock cycle => decoder reg will decode the number pressed
    // note however - if user pressed (2nd time) i.e., button is pressed on same row, then it won't detect  
    
    logic [19:0] sclk;
    logic [3:0] decode_reg;
    logic is_a_key_pressed_reg;
    
    always_ff @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin 
            decode_reg <= 4'b0;
            is_a_key_pressed_reg <= 1'b0;
        end 
        else begin
            if (sclk == 20'b11000011010100000) begin
                col <= 4'b0111;
                sclk <= sclk + 1;
            end
            else if (sclk == 20'b11000011010101000) begin
                if (row == 4'b0111) begin
                    decode_reg <= 4'b0001; //1
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1011) begin
                    decode_reg <= 4'b0100; //4
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1101) begin
                    decode_reg <= 4'b0111; //7
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1110) begin
                    decode_reg <= 4'b0000; //0
                    is_a_key_pressed_reg <= 1'b1;
                end
                else begin
                    decode_reg <= decode_reg; 
                    is_a_key_pressed_reg <= 1'b0;
                end
                sclk <= sclk + 1;   
            end  
              
            if (sclk == 20'b110000110101000000) begin
                col <= 4'b1011;
                sclk <= sclk + 1;
            end  
            else if (sclk == 20'b110000110101001000) begin
                if (row == 4'b0111) begin
                    decode_reg <= 4'b0010; //2
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1011) begin
                    decode_reg <= 4'b0101; //5
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1101) begin
                    decode_reg <= 4'b1000; //8
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1110) begin
                    decode_reg <= 4'b1111; //F
                    is_a_key_pressed_reg <= 1'b1;
                end
                else begin
                    decode_reg <= decode_reg; 
                    is_a_key_pressed_reg <= 1'b0;
                end
                sclk <= sclk + 1; 
            end
            
            if (sclk == 20'b1001001001111100000) begin
                col <= 4'b1101;
                sclk <= sclk + 1;
            end  
            else if (sclk == 20'b1001001001111101000) begin
                if (row == 4'b0111) begin
                    decode_reg <= 4'b0011; //3
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1011) begin
                    decode_reg <= 4'b0110; //6
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1101) begin
                    decode_reg <= 4'b1001; //9
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1110) begin
                    decode_reg <= 4'b1110; //E
                    is_a_key_pressed_reg <= 1'b1;
                end
                else begin
                    decode_reg <= decode_reg; 
                    is_a_key_pressed_reg <= 1'b0;
                end
                sclk <= sclk + 1; 
            end
            
            if (sclk == 20'b1100001101010000000) begin
                col <= 4'b1110;
                sclk <= sclk + 1;
            end  
            else if (sclk == 20'b1100001101010001000) begin
                if (row == 4'b0111) begin
                    decode_reg <= 4'b1010; //A
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1011) begin
                    decode_reg <= 4'b1011; //B
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1101) begin
                    decode_reg <= 4'b1100; //C
                    is_a_key_pressed_reg <= 1'b1;
                end
                else if (row == 4'b1110) begin
                    decode_reg <= 4'b1101; //D
                    is_a_key_pressed_reg <= 1'b1;
                end
                else begin
                    decode_reg <= decode_reg; 
                    is_a_key_pressed_reg <= 1'b0;
                end
                sclk <= sclk + 1; 
            end            
                  
        end    
    end
    
    assign decode_out = decode_reg;
    assign is_a_key_pressed = is_a_key_pressed_reg;
    
endmodule
