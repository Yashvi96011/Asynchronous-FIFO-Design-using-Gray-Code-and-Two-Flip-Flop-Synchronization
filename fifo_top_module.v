module fifotop #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3,
    parameter S1 = ADDR_WIDTH
)(
    input wire                     wclk,
    input wire                     rclk,
    input wire                     wen,
    input wire                     ren,
    input wire                     wrst,
    input wire                     rrst,
    input wire [DATA_WIDTH-1:0]    data_in,
    output wire [DATA_WIDTH-1:0]   data_out,
    output wire                    full,
    output wire                    empty
);

    wire [ADDR_WIDTH:0] binary_wptr;
    wire [ADDR_WIDTH:0] binary_rptr;
    wire [ADDR_WIDTH:0] gray_wptr;
    wire [ADDR_WIDTH:0] gray_rptr;

    // Synchronized pointers
    wire [ADDR_WIDTH:0] gray_wptr_syn;
    wire [ADDR_WIDTH:0] gray_rptr_syn;

    // Read pointer synchronized into write clock domain
    synchronizer #(S1) sync_r2w (
        .clk          (wclk),
        .rst          (wrst),
        .gray_wptr    (gray_rptr),
        .ff2_gray_ptr (gray_rptr_syn)
    );

    // Write pointer synchronized into read clock domain
    synchronizer #(S1) sync_w2r (
        .clk          (rclk),
        .rst          (rrst),
        .gray_wptr    (gray_wptr),
        .ff2_gray_ptr (gray_wptr_syn)
    );

    // Write pointer block
    write_pointer #(S1) write_block (
        .wclk          (wclk),
        .wrst          (wrst),
        .wen           (wen),
        .gray_rptr_syn (gray_rptr_syn),
        .full          (full),
        .binary_wptr   (binary_wptr),
        .gray_wptr     (gray_wptr)
    );

    // Read pointer block
    rdptr_handle #(S1) read_block (
        .rclk          (rclk),
        .rrst          (rrst),
        .ren           (ren),
        .gray_wptr_syn (gray_wptr_syn),
        .empty         (empty),
        .gray_rptr     (gray_rptr),
        .binary_rptr   (binary_rptr)
    );

    // FIFO memory
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(1 << ADDR_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) mem_block (
        .wclk        (wclk),
        .rclk        (rclk),
        .data_in     (data_in),
        .full        (full),
        .empty       (empty),
        .wen         (wen),
        .ren         (ren),
        .binary_wptr (binary_wptr),
        .binary_rptr (binary_rptr),
        .data_out    (data_out)
    );



endmodule


// module fifotop (
//     input  wire        wclk,
//     input  wire        rclk,
//     input  wire        w_en,
//     input  wire        r_en,
//     input  wire        w_rst,
//     input  wire        r_rst,
//     input  wire [7:0]  data_in,
//     output wire [7:0]  data_out,
//     output wire        full,
//     output wire        empty
// );


//     wire [3:0] b_wptr;
//     wire [3:0] b_rptr;
//     wire [3:0] g_wptr;
//     wire [3:0] g_rptr;

//     // Synchronized pointers
//     wire [3:0] g_wptr_sync;
//     wire [3:0] g_rptr_sync;

//     // Synchronizer: Read pointer → Write clock domain
//     two_ff_syn sync_r2w (
//         .wptr_gray       (g_rptr),
//         .rclk            (wclk),
//         .rrst_n          (w_rst),
//         .wptr_gray_sync  (g_rptr_sync)
//     );

//     // Synchronizer: Write pointer → Read clock domain
//     two_ff_syn sync_w2r (
//         .wptr_gray       (g_wptr),
//         .rclk            (rclk),
//         .rrst_n          (r_rst),
//         .wptr_gray_sync  (g_wptr_sync)
//     );

//     // Write pointer handler
//     wptr_handler write_ptr_block (
//         .w_clk       (wclk),
//         .w_rst       (w_rst),
//         .w_en        (w_en),
//         .g_rptr_sync (g_rptr_sync),
//         .g_wptr      (g_wptr),
//         .full        (full),
//         .b_wptr      (b_wptr)
//     );

//     // Read pointer handler
//     rdptr_handle read_ptr_block (
//         .rclk        (rclk),
//         .r_rst       (r_rst),
//         .r_en        (r_en),
//         .g_wptr_sync (g_wptr_sync),
//         .empty       (empty),
//         .g_rptr      (g_rptr),
//         .b_rptr      (b_rptr)
//     );

//     // FIFO memory
//     fifo_mem mem_block (
//         .wclk     (wclk),
//         .rclk     (rclk),
//         .data_in  (data_in),
//         .full     (full),
//         .empty    (empty),
//         .w_en     (w_en),
//         .r_en     (r_en),
//         .b_wptr   (b_wptr),
//         .b_rptr   (b_rptr),
//         .data_out (data_out)
//     );

// endmodule
