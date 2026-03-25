module fifotop (
    input  wire        wclk,
    input  wire        rclk,
    input  wire        w_en,
    input  wire        r_en,
    input  wire        w_rst,
    input  wire        r_rst,
    input  wire [7:0]  data_in,
    output wire [7:0]  data_out,
    output wire        full,
    output wire        empty
);


    wire [3:0] b_wptr;
    wire [3:0] b_rptr;
    wire [3:0] g_wptr;
    wire [3:0] g_rptr;

    // Synchronized pointers
    wire [3:0] g_wptr_sync;
    wire [3:0] g_rptr_sync;

    // Synchronizer: Read pointer → Write clock domain
    two_ff_syn sync_r2w (
        .wptr_gray       (g_rptr),
        .rclk            (wclk),
        .rrst_n          (w_rst),
        .wptr_gray_sync  (g_rptr_sync)
    );

    // Synchronizer: Write pointer → Read clock domain
    two_ff_syn sync_w2r (
        .wptr_gray       (g_wptr),
        .rclk            (rclk),
        .rrst_n          (r_rst),
        .wptr_gray_sync  (g_wptr_sync)
    );

    // Write pointer handler
    wptr_handler write_ptr_block (
        .w_clk       (wclk),
        .w_rst       (w_rst),
        .w_en        (w_en),
        .g_rptr_sync (g_rptr_sync),
        .g_wptr      (g_wptr),
        .full        (full),
        .b_wptr      (b_wptr)
    );

    // Read pointer handler
    rdptr_handle read_ptr_block (
        .rclk        (rclk),
        .r_rst       (r_rst),
        .r_en        (r_en),
        .g_wptr_sync (g_wptr_sync),
        .empty       (empty),
        .g_rptr      (g_rptr),
        .b_rptr      (b_rptr)
    );

    // FIFO memory
    fifo_mem mem_block (
        .wclk     (wclk),
        .rclk     (rclk),
        .data_in  (data_in),
        .full     (full),
        .empty    (empty),
        .w_en     (w_en),
        .r_en     (r_en),
        .b_wptr   (b_wptr),
        .b_rptr   (b_rptr),
        .data_out (data_out)
    );

endmodule
