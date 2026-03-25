module fifo_mem #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8,
    parameter ADDR_WIDTH = 3
)(
    input  wire                     wclk,
    input  wire                     rclk,
    input  wire [DATA_WIDTH-1:0]    data_in,
    input  wire                     full,
    input  wire                     empty,
    input  wire                     w_en,
    input  wire                     r_en,
    input  wire [ADDR_WIDTH:0]      b_wptr,
    input  wire [ADDR_WIDTH:0]      b_rptr,
    output wire [DATA_WIDTH-1:0]    data_out
);

    // Memory array
    reg [DATA_WIDTH-1:0] fifo_array [0:FIFO_DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if ((w_en == 1'b1) && (full == 1'b0)) begin
            fifo_array[b_wptr[ADDR_WIDTH-1:0]] <= data_in;
        end
    end

    // Read operation (combinational)
    assign data_out = fifo_array[b_rptr[ADDR_WIDTH-1:0]];

endmodule
