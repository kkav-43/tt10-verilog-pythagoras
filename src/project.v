`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square root output
    output wire [7:0] uio_out,  // Unused IOs
    output wire [7:0] uio_oe,   // Unused IO enable
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock signal
    input  wire        rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0] sqrt_result;
    reg [15:0] left, right, mid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;
            sum_squares <= 16'd0;
            sqrt_result <= 8'd0;
        end else begin
            // Compute sum of squares
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);

            // Initialize Binary Search
            left  <= 0;
            right <= 255; // Max possible sqrt result for 16-bit numbers

            // Perform 8 iterations of binary search (log2(256) = 8)
            repeat (8) begin
                mid = (left + right + 1) >> 1; // mid = (left + right) / 2

                if (mid * mid <= sum_squares)
                    left = mid;  // Mid is a valid sqrt candidate
                else
                    right = mid - 1;  // Reduce search space
            end

            sqrt_result <= left; // Final square root value
            uo_out <= sqrt_result;
        end
    end

    wire _unused = &{ena, 1'b0}; // Unused enable signal

endmodule
