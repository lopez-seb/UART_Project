`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//          T O P MODULE            //
//              for                 //
//                                  //
//      U A R T tx and rx           //
//////////////////////////////////////


module TOP(
    input signal,
    input CLK, RST,
    output signal_out
    );

wire [7:0] data;
wire start;
wire finish;
    
//  Instantiating modules
UART_rx rx1 (
            .CLK(CLK),
            .RST(RST),
            .signal(signal),
            .rom(data),
            .start(start),
            .finish(finish)
            );

UART_tx tx1 (
            .CLK(CLK),
            .RST(RST),
            .rom(data),
            .start(start),
            .sig_out(signal_out),
            .finish(finish)
            );

endmodule
