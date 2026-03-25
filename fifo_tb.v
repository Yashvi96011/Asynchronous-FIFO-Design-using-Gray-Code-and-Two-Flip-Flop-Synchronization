`timescale 1ns/1ps

module top;

    // Inputs
    reg wclk, rclk;
    reg w_en, r_en;
    reg w_rst, r_rst;
    reg [7:0] data_in;

    // Outputs
    wire [7:0] data_out;
    wire full, empty;

    // Instantiate DUT
    fifotop dut (
        .wclk(wclk),
        .rclk(rclk),
        .w_en(w_en),
        .r_en(r_en),
        .w_rst(w_rst),
        .r_rst(r_rst),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

   
    always #5 wclk = ~wclk;

   
    always #7 rclk = ~rclk;

    // Stimulus
    initial begin
        // Initialize
        wclk = 0; 
        rclk = 0;
        w_en = 0; 
        r_en = 0;
        w_rst = 0; 
        r_rst = 0;
        data_in = 0;

        // Apply reset
        #20;
        w_rst = 1;
        r_rst = 1;

        // WRITE PHASE 
        #10;
        repeat (10) begin
            @(posedge wclk);
            if (!full) begin
                w_en = 1;
                data_in = data_in + 1;
            end else begin
                w_en = 0;
            end
        end
        w_en = 0;

        //  READ PHASE 
        #20;
        repeat (10) begin
            @(posedge rclk);
            if (!empty) begin
                r_en = 1;
            end else begin
                r_en = 0;
            end
        end
        r_en = 0;

       
        // Finish simulation
        #50;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | W_EN=%b R_EN=%b | DATA_IN=%h DATA_OUT=%h | FULL=%b EMPTY=%b",
                  $time, w_en, r_en, data_in, data_out, full, empty);
    end

endmodule
