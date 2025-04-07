`default_nettype none
`timescale 1ns / 1ps

/* Tiny Tapeout-compatible testbench
   - Generates clock/reset
   - Supports external test with cocotb or manual stimuli
   - Displays output only on change
*/

module tb ();

  // Dump VCD for waveform viewing
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Signal declarations
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Optional power pins for GL testing
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // DUT instantiation
  tt_um_addon dut (
`ifdef GL_TEST
    .VPWR(VPWR),
    .VGND(VGND),
`endif
    .ui_in(ui_in),
    .uio_in(uio_in),
    .uo_out(uo_out),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(ena),
    .clk(clk),
    .rst_n(rst_n)
  );

  // Clock generation: 100 MHz
  initial clk = 0;
  always #5 clk = ~clk;

  // Output monitoring (on value change)
  reg [7:0] last_out = 8'hFF;
  always @(posedge clk) begin
    if (uo_out !== last_out) begin
      $display("Time=%0t | X=%0d Y=%0d | sqrt=%0d", $time, ui_in, uio_in, uo_out);
      last_out <= uo_out;
    end
  end

  // Main stimulus
  initial begin
    // Default values
    ui_in   = 0;
    uio_in  = 0;
    ena     = 0;
    rst_n   = 0;

    // Apply reset
    #20 rst_n = 1;
    #20;

    // Test 1: X = 3, Y = 4 --> sqrt(25) = 5
    ui_in = 8'd3;
    uio_in = 8'd4;
    ena = 1;
    #10 ena = 0;
    #100;

    // Test 2: X = 5, Y = 12 --> sqrt(169) = 13
    ui_in = 8'd5;
    uio_in = 8'd12;
    ena = 1;
    #10 ena = 0;
    #100;

    // Test 3: X = 7, Y = 24 --> sqrt(625) = 25
    ui_in = 8'd7;
    uio_in = 8'd24;
    ena = 1;
    #10 ena = 0;
    #100;

    // Finish
    $finish;
  end

endmodule
