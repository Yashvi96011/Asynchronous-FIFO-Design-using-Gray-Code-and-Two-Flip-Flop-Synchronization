module synchronizer #(parameter S1=3)
(
    input clk,
    input rst,
    input [S1:0] gray_wptr,
    output reg [S1:0] ff2_gray_ptr
);

    reg [S1:0] ff1_gray_ptr;

    always @(posedge clk or negedge rst)
    begin
        if (!rst)
        begin
            ff1_gray_ptr <= 0;
            ff2_gray_ptr <= 0;
        end
        else
        begin
            ff1_gray_ptr <= gray_wptr;
            ff2_gray_ptr <= ff1_gray_ptr;
        end
    end

endmodule

// module two_ff_syn #(parameter S1 = 3)
// (
//     input  wire [S1:0] wptr_gray,
//     input  wire        rclk,
//     input  wire        rrst_n,
//     output reg  [S1:0] wptr_gray_sync
// );

// reg [S1:0] wptr_gray_ff1;

// always @(posedge rclk or negedge rrst_n) begin
//     if (!rrst_n) begin
//         {wptr_gray_ff1, wptr_gray_sync} <= 0;
//     end 
//     else begin
//         wptr_gray_ff1 <= wptr_gray;
//         wptr_gray_sync <= wptr_gray_ff1;
//     end
// end

// endmodule
