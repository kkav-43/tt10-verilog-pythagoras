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

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0]  left, right;
    reg [7:0]  mid;
    reg [3:0]  step;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 0;
            left        <= 0;
            right       <= 8'd255;
            mid         <= 0;
            step        <= 0;
            uo_out      <= 0;
            busy        <= 0;
        end else begin
            if (ena && !busy) begin
                sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
                left        <= 0;
                right       <= 8'd255;
                step        <= 0;
                busy        <= 1;
                uo_out      <= 0;
            end else if (busy) begin
                if (step < 8) begin
                    mid = (left + right + 1) >> 1;
                    if ((mid * mid) <= sum_squares)
                        left <= mid;
                    else
                        right <= mid - 1;
                    step <= step + 1;
                end else begin
                    uo_out <= left;
                    busy   <= 0;
                end
            end
        end
    end

endmodule
