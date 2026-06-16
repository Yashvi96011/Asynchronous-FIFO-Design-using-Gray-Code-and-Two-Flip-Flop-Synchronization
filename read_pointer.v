module rdptr_handle #(parameter S1=3)
(
    input  wire        rclk,
    input  wire        rrst,
    input  wire        ren,
    input  wire [S1:0] gray_wptr_syn,
    output reg         empty,
    output reg  [S1:0] gray_rptr,
    output reg  [S1:0] binary_rptr
);

    wire [S1:0] bptr;
    wire [S1:0] b_to_g;
    wire        empty_flag;

    // Binary pointer increment
    assign bptr = binary_rptr + ((ren == 1'b1) && (empty == 1'b0));

    // Binary to Gray conversion
    assign b_to_g = (bptr >> 1) ^ bptr;

    // Empty condition
    assign empty_flag = (b_to_g == gray_wptr_syn);

    // Sequential block for pointers
    always @(posedge rclk or negedge rrst) begin
        if (!rrst)
          begin
          binary_rptr <= 0;
          gray_rptr   <= 0;
        end
        else begin
            binary_rptr <= bptr;
            gray_rptr   <= b_to_g;
        end
    end

    // Sequential block for empty flag
    always @(posedge rclk or negedge rrst) begin
        if (!rrst)
            empty <= 1'b1;
        else
            empty <= empty_flag;
    end

endmodule

// module rdptr_handle (
//     input  wire        rclk,
//     input  wire        r_rst,
//     input  wire        r_en,
//     input  wire [3:0]  g_wptr_sync,
//     output reg         empty,
//     output reg  [3:0]  g_rptr,
//     output reg  [3:0]  b_rptr
// );

   
//     wire [3:0] binary_next;
//     wire [3:0] gray_next;
//     wire       empty_flag;

//     // Binary pointer increment
//     assign binary_next = b_rptr + ((r_en == 1'b1) && (empty == 1'b0));

//     // Binary to Gray conversion
//     assign gray_next = (binary_next >> 1) ^ binary_next;

//     // Empty condition
//     assign empty_flag = (gray_next == g_wptr_sync);

//     // Sequential block for pointers
//     always @(posedge rclk or negedge r_rst) begin
//         if (!r_rst) begin
//             g_rptr <= 4'b0000;
//             b_rptr <= 4'b0000;
//         end else begin
//             b_rptr <= binary_next;
//             g_rptr <= gray_next;
//         end
//     end

//     // Sequential block for empty flag
//     always @(posedge rclk or negedge r_rst) begin
//         if (!r_rst)
//             empty <= 1'b1;
//         else
//             empty <= empty_flag;
//     end

// endmodule
