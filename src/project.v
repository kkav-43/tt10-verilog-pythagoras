`default_nettype none
`timescale 1ns / 1ps

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square Root Output
    output wire [7:0] uio_out,  // Unused IOs (set to 0)
    output wire [7:0] uio_oe,   // Unused IO Enable (set to 0)
    input  wire       ena,      // Enable (active high)
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset
);

    // Set unused outputs to zero
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Internal registers
    reg [15:0] sum_squares;     // Stores X^2 + Y^2
    reg [7:0]  left, right;     // Binary search boundaries
    reg [7:0]  mid;             // Middle point for binary search
    reg [3:0]  step;            // Step counter for the binary search
    reg        busy;            // Indicates calculation in progress

    // Binary search for square root
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            sum_squares <= 16'b0;
            left        <= 8'b0;
            right       <= 8'd255;
            mid         <= 8'b0;
            step        <= 4'b0;
            uo_out      <= 8'b0;
            busy        <= 1'b0;
        end else begin
            if (ena && !busy) begin
                // Start new calculation when enabled and not busy
                // Calculate X^2 + Y^2 with proper width to avoid overflow
                sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
                left        <= 8'b0;
                right       <= 8'd255;
                step        <= 4'd0;  // Start at 0 for cleaner logic
                busy        <= 1'b1;
                uo_out      <= 8'b0;  // Clear output at start
            end else if (busy) begin
                if (step < 8) begin  // Less than 8 steps (0-7)
                    // Calculate midpoint - use blocking to update immediately
                    mid = (left + right + 1) >> 1;
                    
                    // Update search boundaries
                    if ((mid * mid) <= sum_squares)
                        left <= mid;
                    else
                        right <= mid - 1;
                    
                    // Move to next step
                    step <= step + 1;
                end else begin
                    // Final step - output result and clear busy flag
                    uo_out <= left;
                    busy   <= 1'b0;
                end
            end
        end
    end

endmodule
