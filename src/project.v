`default_nettype none // Disable implicit net declarations
`timescale 1ns / 1ps  // Define time unit and precision

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square Root Output
    output wire [7:0] uio_out,  // Unused IOs (set to 0)
    output wire [7:0] uio_oe,   // Unused IO Enable (set to 0)
    input  wire        ena,     // Enable (unused)
    input  wire        clk,     // Clock signal
    input  wire        rst_n    // Active-low reset
);

    // Set unused outputs to zero
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Declare registers
    reg [15:0] sum_squares;  // Store sum of squares (X² + Y²)
    reg [7:0] sqrt_result;   // Store calculated square root
    reg [15:0] left, right, mid; // Registers for binary search

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;  // Reset output
            sum_squares <= 16'd0; // Reset sum of squares
            sqrt_result <= 8'd0;  // Reset square root
        end else begin
            // Compute sum of squares: X² + Y²
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);

            // Binary search initialization
            left  <= 0;
            right <= 255; // Maximum possible square root for a 16-bit number

            // Perform 8 iterations of binary search (log2(256) = 8)
            repeat (8) begin
                mid = (left + right + 1) >> 1; // mid = (left + right) / 2

                if (mid * mid <= sum_squares)
                    left = mid;  // Keep mid as a valid sqrt candidate
                else
                    right = mid - 1;  // Reduce search space
            end

            sqrt_result <= left; // Assign final square root value
            uo_out <= sqrt_result;
        end
    end

    // Unused enable signal
    wire _unused = &{ena, 1'b0}; 

endmodule
