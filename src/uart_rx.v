module uart_rx #(
    parameter CLK_FREQ = 27000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rx,
    output reg [7:0] data_out,
    output reg done
);

    localparam CYCLE_PER_BIT = CLK_FREQ / BAUD_RATE;
    
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state = IDLE;
    reg [15:0] cycle_cnt = 0;
    reg [2:0] bit_cnt = 0;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                done <= 0;
                cycle_cnt <= 0;
                bit_cnt <= 0;
                if (rx == 0) // start bit detected (line goes low)
                    state <= START;
            end

            START: begin
                if (cycle_cnt == (CYCLE_PER_BIT / 2)) begin // sample at middle
                    if (rx == 0) begin
                        cycle_cnt <= 0;
                        state <= DATA;
                    end else
                        state <= IDLE; // false start
                end else
                    cycle_cnt <= cycle_cnt + 1;
            end

            DATA: begin
                if (cycle_cnt == CYCLE_PER_BIT - 1) begin
                    cycle_cnt <= 0;
                    data_out[bit_cnt] <= rx;
                    if (bit_cnt == 7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end else
                    cycle_cnt <= cycle_cnt + 1;
            end

            STOP: begin
                if (cycle_cnt == CYCLE_PER_BIT - 1) begin
                    done <= 1;
                    state <= IDLE;
                end else
                    cycle_cnt <= cycle_cnt + 1;
            end
        endcase
    end
endmodule