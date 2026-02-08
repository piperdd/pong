//module rotary_encoder(
//    input clk,
//    input rst,
//    input a,
//    input b,
//    output reg cw,
//    output reg ccw
//);

//reg [1:0] shift_reg;

//always@(posedge clk or negedge rst) begin

//    if (~rst) begin
//        cw <= 0;
//        ccw <= 0;
//	end else begin
//        shift_reg <= {shift_reg[0], a};

//        if (shift_reg == 2'b01) begin
//            if (b) begin
//                cw <= 1;
//                ccw <= 0;
//            end else begin
//                ccw <= 1;
//                cw <= 0;
//            end
//        end else begin
//            cw <= 0;
//            ccw <= 0;
//        end
//    end
//end


//endmodule

module rotary_encoder(
    input clk,
    input rst,
    input a,
    input b,
    output reg cw,
    output reg ccw
);

    reg [2:0] a_sync, b_sync;
    
    reg [15:0] timer;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            a_sync <= 3'b111;
            b_sync <= 3'b111;
            timer  <= 0;
            cw     <= 0;
            ccw    <= 0;
        end else begin
            cw  <= 0; // ensure pulse is only 1 clock wide
            ccw <= 0;

            if (timer < 27000) begin
                timer <= timer + 1;
            end else begin
                timer <= 0;
                a_sync <= {a_sync[1:0], a};
                b_sync <= {b_sync[1:0], b};

                if (a_sync[2] == 1 && a_sync[1] == 0) begin
                    if (b_sync[1] == 1) cw <= 1;
                    else                ccw <= 1;
                end
            end
        end
    end
endmodule