module digit_module(
    input [7:0] xPos,
    input [7:0] yPos,
    input [7:0] size,
    input [7:0] digit_num,
    
	input [15:0] pixelcnt,
    input [3:0] digit,
    output pixel
);

localparam TOP_BAR   = 0;
localparam MID_BAR   = 1;
localparam BOT_BAR   = 2;
localparam TOP_LEFT  = 3;
localparam TOP_RIGHT = 4;
localparam BOT_LEFT  = 5;
localparam BOT_RIGHT = 6;

wire [6:0] mapping;
wire [15:0] x, y;

assign x = pixelcnt % 240;
assign y = pixelcnt / 240;

assign mapping[TOP_BAR] = (x >= xPos + (4*size*digit_num) && x < xPos + (3*size) + (4*size*digit_num) && y >= yPos && y < yPos + size);
assign mapping[MID_BAR] = (x >= xPos + (4*size*digit_num) && x < xPos + (3*size) + (4*size*digit_num) && y >= yPos + (2*size) && y < yPos + (3*size));
assign mapping[BOT_BAR] = (x >= xPos + (4*size*digit_num) && x < xPos + (3*size) + (4*size*digit_num) && y >= yPos + (4*size) && y < yPos + (5*size));
assign mapping[TOP_LEFT] = (y >= yPos && y < yPos + (3*size) && x >= xPos + (4*size*digit_num) && x < xPos + size + (4*size*digit_num));
assign mapping[TOP_RIGHT] = (y >= yPos && y < yPos + (3*size) && x >= xPos + (2*size) + (4*size*digit_num) && x < xPos + (3*size) + (4*size*digit_num));
assign mapping[BOT_LEFT] = (y >= yPos + (2*size) && y < yPos + (5*size) && x >= xPos + (4*size*digit_num) && x < xPos + size + (4*size*digit_num));
assign mapping[BOT_RIGHT] = (y >= yPos + (2*size) && y < yPos + (5*size) && x >= xPos + (2*size) + (4*size*digit_num) && x < xPos + (3*size) + (4*size*digit_num));

reg [6:0] segments;
always @(*) begin
    case(digit)
        0: segments = 7'b1111101;
        1: segments = 7'b1010000;
        2: segments = 7'b0110111;
        3: segments = 7'b1010111;
        4: segments = 7'b1011010;
        5: segments = 7'b1001111;
        6: segments = 7'b1101111;
        7: segments = 7'b1010001;
        8: segments = 7'b1111111;
        9: segments = 7'b1011111;
        default: segments = 7'b0000000; 
    endcase
end

assign pixel = |(mapping & segments);

endmodule