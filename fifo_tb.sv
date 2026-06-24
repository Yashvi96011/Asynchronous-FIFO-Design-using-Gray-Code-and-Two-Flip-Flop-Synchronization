`timescale 1ns/1ps

module fifo_tb;

    // Inputs
    logic wclk, rclk;
    logic wrst, rrst;
    logic wen, ren;
    logic [7:0] data_in;

    // Outputs
    logic [7:0] data_out;
    logic full, empty;

    // DUT
    fifotop dut(
        .wclk(wclk),
        .rclk(rclk),
        .wen(wen),
        .ren(ren),
        .wrst(wrst),
        .rrst(rrst),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );
  
  //clock generation 
  initial 
    begin
      wclk=0;
      forever #5 wclk=~wclk;
    end
  
  initial begin
        rclk = 0;
        forever #7 rclk = ~rclk;
    end
  
   initial begin
        wrst = 0;
        rrst = 0;
        wen  = 0;
        ren  = 0;
        data_in = 0;

        #20;
        wrst = 1;
        rrst = 1;
     
     repeat(10)
       begin
         @(posedge wclk);
         wen=1;
         data_in=data_in+1;
       end
      @(posedge wclk);
        wen = 0;

        // Read 5 values
        repeat(10) begin
            @(posedge rclk);
            ren = 1;
        end

        @(posedge rclk);
        ren = 0;

        #50;
        $finish;
    end
  
  //functional coverage 
 covergroup fifo_cov @(posedge wclk);

    cp_wen : coverpoint wen {
        bins on  = {1};
        bins off = {0};
    }

    cp_ren : coverpoint ren {
        bins on  = {1};
        bins off = {0};
    }

    cp_full : coverpoint full {
        bins yes = {1};
        bins no  = {0};
    }

    cp_empty : coverpoint empty {
        bins yes = {1};
        bins no  = {0};
    }

    // Simultaneous read and write
    cross cp_wen, cp_ren;

    // Write attempts when full/not full
    cross cp_wen, cp_full;

    // Read attempts when empty/not empty
    cross cp_ren, cp_empty;

endgroup

fifo_cov cg = new();
    
 
  //SVA
  property full_en_check;
    @(posedge wclk)
    full|->!wen;
  endproperty
  assert property(full_en_check)
    else
      $error("Write attempted when fifo is full");
    
    property empty_en_check;
      @(posedge rclk)
      empty|->!ren;
    endproperty 
    assert property(empty_en_check)
      else
        $error("Read attempted when fifo is empty");
      
      initial begin
    $monitor("time=%0t data_in=%0d data_out=%0d wen=%b ren=%b full=%b empty=%b", $time, data_in, data_out, wen, ren, full, empty);
end

initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, fifo_tb);
end

final begin
   
    $display("Functional Coverage = %0.2f %%", cg.get_coverage());
   
end


// `timescale 1ns/1ps

// module top;

//     // Inputs
//     reg wclk, rclk;
//     reg w_en, r_en;
//     reg w_rst, r_rst;
//     reg [7:0] data_in;

//     // Outputs
//     wire [7:0] data_out;
//     wire full, empty;

//     // Instantiate DUT
//     fifotop dut (
//         .wclk(wclk),
//         .rclk(rclk),
//         .w_en(w_en),
//         .r_en(r_en),
//         .w_rst(w_rst),
//         .r_rst(r_rst),
//         .data_in(data_in),
//         .data_out(data_out),
//         .full(full),
//         .empty(empty)
//     );

   
//     always #5 wclk = ~wclk;

   
//     always #7 rclk = ~rclk;

//     // Stimulus
//     initial begin
//         // Initialize
//         wclk = 0; 
//         rclk = 0;
//         w_en = 0; 
//         r_en = 0;
//         w_rst = 0; 
//         r_rst = 0;
//         data_in = 0;

//         // Apply reset
//         #20;
//         w_rst = 1;
//         r_rst = 1;

//         // WRITE PHASE 
//         #10;
//         repeat (10) begin
//             @(posedge wclk);
//             if (!full) begin
//                 w_en = 1;
//                 data_in = data_in + 1;
//             end else begin
//                 w_en = 0;
//             end
//         end
//         w_en = 0;

//         //  READ PHASE 
//         #20;
//         repeat (10) begin
//             @(posedge rclk);
//             if (!empty) begin
//                 r_en = 1;
//             end else begin
//                 r_en = 0;
//             end
//         end
//         r_en = 0;

       
//         // Finish simulation
//         #50;
//         $finish;
//     end

//     // Monitor signals
//     initial begin
//         $monitor("Time=%0t | W_EN=%b R_EN=%b | DATA_IN=%h DATA_OUT=%h | FULL=%b EMPTY=%b",
//                   $time, w_en, r_en, data_in, data_out, full, empty);
//     end

// endmodule
