`default_nettype none
`timescale 1ns / 1ps

module tb ();

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // DUT Instance
  tt_um_addon dut (
      .ui_in(ui_in),
      .uo_out(uo_out),
      .uio_in(uio_in),
      .uio_out(uio_out),
      .uio_oe(uio_oe),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

  // Clock generation
  always #5 clk = ~clk;

  // VCD Dump
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Test sequence
  initial begin
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 0;
    uio_in = 0;

    #10 rst_n = 1;
    #10;

    test_case(8'd3,  8'd4);   // sqrt(9 + 16) = 5
    test_case(8'd5,  8'd12);  // sqrt(25 + 144) = 13
    test_case(8'd7,  8'd24);  // sqrt(49 + 576) = 25
    test_case(8'd8,  8'd15);  // sqrt(64 + 225) = 17
    test_case(8'd16, 8'd63);  // sqrt(256 + 3969) = 65

    #100;
    $finish;
  end

  // Helper task
  task test_case(input [7:0] x, input [7:0] y);
    begin
      @(posedge clk);
      ui_in = x;
      uio_in = y;
      ena = 1;
      @(posedge clk);
      ena = 0;

      // Wait until busy goes low
      wait (dut.busy == 1);
      wait (dut.busy == 0);
    end
  endtask

  // Print output only when result is ready
  reg prev_busy;
  always @(posedge clk) begin
    prev_busy <= dut.busy;
    if (prev_busy && !dut.busy) begin
      $display("Time=%0t | X=%0d Y=%0d | sqrt=%0d", 
               $time, ui_in, uio_in, uo_out);
    end
  end

endmodule
