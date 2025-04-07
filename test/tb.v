`default_nettype none
`timescale 1ns / 1ps

module tb ();
  reg [7:0] ui_in;    // X input
  reg [7:0] uio_in;   // Y input  
  wire [7:0] uo_out;  // Square root output
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  reg clk;
  reg rst_n;
  reg ena;

  // Instantiate your module
  tt_um_addon dut (
    .ui_in(ui_in),
    .uio_in(uio_in),
    .uo_out(uo_out),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(ena),
    .clk(clk),
    .rst_n(rst_n)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test cases
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    
    // Initialize
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 0;
    uio_in = 0;
    
    // Release reset
    #10 rst_n = 1;
    
    // Test case 1: X=3, Y=4 (expected sqrt=5)
    #10;
    ui_in = 8'd3;
    uio_in = 8'd4;
    ena = 1;
    #10 ena = 0;
    
    // Wait for calculation
    #200;
    
    // Test case 2: X=5, Y=12 (expected sqrt=13)
    ui_in = 8'd5;
    uio_in = 8'd12;
    ena = 1;
    #10 ena = 0;
    
    // Wait for calculation
    #200;
    
    $finish;
  end
  
  // Monitor outputs
  always @(posedge clk) begin
    if (uo_out != 0)
      $display("Result for inputs %d, %d is %d", ui_in, uio_in, uo_out);
  end
endmodule
