`timescale 1ns / 1ps



module UART_rx#(
            parameter WL = 8
                )(
            input signal, CLK, finish, RST,
            output reg [13:0] count,
            output reg [WL-1:0] rom,
            output reg [3:0] x,
            output reg [1:0] state,
            output reg start
                );
//////////////////////////////////////
localparam UART = 10418;
localparam hAdj = UART/2;
localparam fAdj = UART;
//////////////////////////////////////
parameter s1 = 2'b00; parameter s2 = 2'b01;
parameter s3 = 2'b10; parameter s4 = 2'b11;
//////////////////////////////////////

always @(posedge CLK) begin
    if(RST)begin
        state <= s1;
        start <= 0;
        count <= 0;
        x <= 0;
        end
    else begin
    case(state)
        s1: begin
                if(!signal)begin
                    count <= 0;
//                    start <= 0;
                    state <= s2;
                    end
                else if (finish) start <= 0;
            end
        s2: begin
                if(count==fAdj)begin
                    count <= 0;
                    x <= 0;
                    state <= s3;
                    end
                else count <= count +1;
            end
        s3: begin
                if(count==hAdj)begin
                    rom[x] <= signal;
                    x <= x + 1;
                    count <= count +1;
                    end
                else if(count==fAdj)begin
                    if(x==7)begin
                        count <= 0;
//                        x <= 0;
                        state <= s4;
                        end
                    else count <= 0;
                    end
                else count <= count +1;
            end
        s4: begin
                start <= 1;
                state <= s1;
            end
        endcase
    end
end
endmodule
