# Euclidean Distance Calculator

This TinyTapeout project implements a digital circuit that calculates the Euclidean distance (square root of the sum of squares) between two 8-bit inputs.

## How it Works

1. Takes two 8-bit inputs (X and Y)
2. Calculates X² + Y²
3. Uses binary search to find the square root of the sum
4. Outputs the resulting 8-bit value

## Inputs

- `ui_in[7:0]`: X value (8-bit integer)
- `uio_in[7:0]`: Y value (8-bit integer)
- `ena`: Start calculation when high for one clock cycle
- `clk`: Clock signal
- `rst_n`: Active-low reset

## Outputs

- `uo_out[7:0]`: Square root result (8-bit integer)
- Other outputs are unused

## Usage

1. Set the X value on `ui_in[7:0]`
2. Set the Y value on `uio_in[7:0]`
3. Pulse `ena` high for one clock cycle
4. Wait for calculation to complete (8 clock cycles)
5. Read the result from `uo_out[7:0]`

## Implementation Details

The design uses an iterative binary search algorithm to calculate the square root. It takes 8 clock cycles to compute the result after the `ena` signal is asserted.
