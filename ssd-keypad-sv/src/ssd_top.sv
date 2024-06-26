`timescale 1ns / 1ps

module ssd_top(
    input clk,
    input [3:0] btn,
    input [3:0] sw,
    output [3:0] led,
    output [6:0] seg,
    output chip_sel,
//    output [3:0] col_reg,
//    input [3:0] row_reg
    inout [7:0] kypd
    );
   
    parameter clk_freq = 50_000_000;
    parameter stable_time = 10;
    
    logic rst;
    logic btn1_debounce;
    logic btn1_pulse; // detects btn pulse from debouncer to see if user toggles to switch display on ssd
    logic c_sel; //if btn1_pulse is pressed then display toggles on ssd
//    logic [7:0] kypd_w; Better to avoid doing this since kypd is inout port
    logic is_a_key_pressed;
    logic [3:0] decoder_out;
    
    assign rst = btn[0]; 
//    assign kypd = kypd_w; Better to avoid doing this since kypd is inout port
    
    kypad_decoder kypd_inst1(
        .clk(clk),
        .rst(rst),
        .col(kypd[3:0]),
        .row(kypd[7:4]),
        .decode_out(decoder_out), //decoder_out is decoded from keypad as output 
       .is_a_key_pressed(is_a_key_pressed)
    );
    
    disp_ctrl ssd_i(
        .disp_val(decoder_out), //decoder_out goes as the input to the pmod ssd display
        .seg_out(seg) //outputs the segment display
        );
    
    debounce #(
        .clk_freq(clk_freq),
        .stable_time(stable_time)
        )
        
        db_inst1(
        .clk(clk),
        .rst(rst),
        .button(btn[1]),
        .result(btn1_debounce)
        );
        
    single_pulse_detector #(
        .detect_type(2'b0)
        )
        
        pls_inst_1(
        .clk(clk),
        .rst(rst),
        .input_signal(btn1_debounce),
        .output_pulse(btn1_pulse)
    );
    
    
    always_ff @(posedge rst, posedge clk) begin
        if (rst == 1) begin
            c_sel = 1'b0;
        end    
        else if (btn1_pulse == 1'b1) begin
            c_sel = ~c_sel;
        end
    end      
      
    assign chip_sel = c_sel;
    
endmodule
