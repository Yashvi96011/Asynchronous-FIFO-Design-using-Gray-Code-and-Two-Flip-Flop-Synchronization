module two_ff_syn #(parameter S1 = 3)
(
    input  wire [S1:0] wptr_gray,
    input  wire        rclk,
    input  wire        rrst_n,
    output reg  [S1:0] wptr_gray_sync
);

reg [S1:0] wptr_gray_ff1;

always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
        {wptr_gray_ff1, wptr_gray_sync} <= 0;
    end 
    else begin
        wptr_gray_ff1 <= wptr_gray;
        wptr_gray_sync <= wptr_gray_ff1;
    end
end

endmodule
