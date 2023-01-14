`timescale 1ns / 1ps

module UART_tx#(
        parameter WL = 8
                )(
            input CLK, RST, start,
            input [WL-1:0] rom,
            output reg finish, 
            output reg [1:0] state,
            output reg sig_out         
                );
///////////////////////////////////////                
reg [13:0] count;
reg [2:0] x;
localparam bode = 10418;
///////////////////////////////////////
parameter s1 = 2'b00;   parameter s2 = 2'b01;
parameter s3 = 2'b10;   parameter s4 = 2'b11;
///////////////////////////////////////
always @(posedge CLK) begin
    if(RST)begin
        count <= 0;
        finish <= 1;
        state <= s1;
        x <= 0;
    end
    else begin
        case(state)
            s1: begin
                    count <= 0;
                    x <= 0;
                    if(start) state <= s2;
                    else sig_out <= 1;
                end
            s2: begin
                if(count==bode)begin
                    count <= 0;
                    state <= s3;
                    end
                else begin 
                    count <= count +1;
                    sig_out <= 0;
                    end
                end
            s3: begin
                    if(count==bode)begin
                        if(x==7)state <= s4;
                        else begin
                            x <= x + 1;
                            count <= 0;
                            end
                        end
                    else begin
                        sig_out <= rom[x];
                        count <= count +1;
                        end
                end
            s4: begin
                    sig_out <= 1;
                    finish <= 1;
                    state <= s1;
                end
        endcase
        end
end
endmodule