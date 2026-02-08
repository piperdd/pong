module game_logic(
    input frame_clk,
    input rst,
    input [15:0] pixelcnt,
    input [7:0] rx_data,
    output pixel,
    output reg [7:0] score
);

reg [7:0] xPos;
reg [7:0] yPos;

reg xDirection;
reg yDirection;

localparam width = 8'd50;
localparam half_width = width/2;

localparam minPos = half_width;

localparam maxPos = 8'd135 - half_width;

localparam range = maxPos - minPos;

reg [7:0] barYPos;

assign pixel = ((pixelcnt % 240 >= xPos && pixelcnt % 240 <= xPos + 10) &&
                    (pixelcnt / 240 >= yPos && pixelcnt / 240 <= yPos + 10)) ||
                    ((pixelcnt / 240 >= barYPos - half_width &&  pixelcnt / 240 <= barYPos + half_width) && 
                    pixelcnt % 240 < 5);

always@(posedge frame_clk or negedge rst) begin
    if (~rst) begin
//		clk_cnt <= 0;
//		cmd_index <= 0;
//		init_state <= INIT;
        
        xPos <= 0;
        yPos <= 100;
        xDirection <= 0;
        yDirection <= 0;

        barYPos <= 0;
        score <= 0;
        
	end else begin
        xPos <= xDirection ? xPos + 3 : xPos - 3;
        if (xPos % 240 <= 0 && !xDirection) begin
            xDirection <= ~xDirection; // reverse direction
            if (yPos <= barYPos + half_width && yPos >= barYPos - half_width) begin
                if (score < 99) begin
                    score <= score + 1;
                end
            end else begin
                score <= 0;
            end
        end 

        if (xPos % 240 >= 230 && xDirection) begin
            xDirection <= ~xDirection; // reverse direction
        end 

        yPos <= yDirection ? yPos - 2 : yPos + 2;
        if ((yPos <= 5 && yDirection) || (yPos >= 125 && !yDirection)) begin
            yDirection <= ~yDirection; // reverse direction
        end 

        barYPos <= minPos + ((range * rx_data) / 255);
    end
end

endmodule