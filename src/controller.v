module controller(
    input clk,
    input rst,
    input a,
    input b,
    output reg [7:0] data
);

wire cw, ccw;

rotary_encoder encoder (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .cw(cw),
    .ccw(ccw)
);


always@(posedge clk or negedge rst) begin

    if (~rst) begin
        data <= 15;
	end else begin
        if (cw) begin
            if (data < 230) begin
                data <= data + 20;
            end
        end else if (ccw) begin
            if (data > 20) begin
                data <= data - 20;
            end
        end
    end
end

endmodule