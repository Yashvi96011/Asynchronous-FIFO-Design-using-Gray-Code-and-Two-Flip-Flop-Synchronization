module wptr_handler (
    input  wire        w_clk,
    input  wire        w_rst,
    input  wire        w_en,
    input  wire [3:0]  g_rptr_sync,
    output reg  [3:0]  g_wptr,
    output reg         full,
    output reg  [3:0]  b_wptr
);

    wire        full_flag;
    wire [3:0]  gray_next;
    wire [3:0]  binary_next;

    // Binary pointer increment logic
    assign binary_next = b_wptr + ((w_en == 1'b1) && (full == 1'b0));

    // Binary to Gray conversion
    assign gray_next = (binary_next >> 1) ^ binary_next;

    // Full condition check
    assign full_flag = (g_rptr_sync == {~gray_next[3:2], gray_next[1:0]});

    // Sequential block for pointers
    always @(posedge w_clk or negedge w_rst) begin
        if (!w_rst) begin
            b_wptr <= 4'b0000;
            g_wptr <= 4'b0000;
        end else begin
            b_wptr <= binary_next;
            g_wptr <= gray_next;
        end
    end

    // Sequential block for full flag
    always @(posedge w_clk or negedge w_rst) begin
        if (!w_rst)
            full <= 1'b0;
        else
            full <= full_flag;
    end

endmodule
