# Tiny Tapeout Project: Square Root Pythagoras

## Overview

This project computes the **hypotenuse** using the **Pythagorean theorem**:

\(\text{sqrt\_out} = \sqrt{x^2 + y^2}\)

where `x` and `y` are 8-bit integer inputs. The design utilizes **binary search** to approximate the square root, making it efficient for hardware implementation.

## Hardware Implementation

### **Modules**

- **`tt_um_addon`**: The top module that calculates the sum of squares and performs a binary search to approximate the square root.
- **Binary Search Square Root Algorithm**: Used instead of direct computation for efficient hardware execution.

### **Algorithm Explanation**

1. Compute sum of squares:\
   \(	ext{sum\_squares} = x^2 + y^2\)
2. Use **binary search** to find the integer square root:
   - Initialize `left = 0` and `right = 255`
   - Perform 8 iterations:
     - Set `mid = (left + right + 1) / 2`
     - If `mid^2 <= sum_squares`, update `left = mid`
     - Else, update `right = mid - 1`
   - Final `left` value is the approximate square root.

### **Pin Mapping**

| Pin Name   | Description             |
| ---------- | ----------------------- |
| `ui[7:0]`  | 8-bit `x` input         |
| `uio[7:0]` | 8-bit `y` input         |
| `uo[7:0]`  | 8-bit `sqrt_out` output |

## Simulation & Testing

### **Testbench (Verilog)**

- `tb.v` applies test cases: `(3,4) → 5`, `(5,12) → 13`, `(6,8) → 10`.
- Uses **posedge clock** to evaluate output.
- Results are compared against expected values.

### **Software Simulation (Cocotb)**

1. Run `make test` to execute the testbench.
2. Applies different `x` and `y` values.
3. Passes if `sqrt_out` matches expected results within a margin.

### **Hardware Testing**

1. Load the synthesized design onto an FPGA or TinyTapeout ASIC.
2. Provide binary inputs for `x` and `y`.
3. Verify `sqrt_out` output using an oscilloscope or logic analyzer.

## Constraints & Limitations

- **Integer precision**: Limited to 8-bit results.
- **Binary search approximation**: May have minor rounding errors.
- **No floating-point support**: Designed for low-power embedded systems.

## Applications

- **Sensor Data Processing**: Distance calculation from sensor data.
- **Robotics**: Simple 2D distance measurement.
- **Embedded Systems**: Efficient arithmetic without complex operations.

## Future Improvements

- Increase bit-width for higher precision.
- Implement floating-point calculations for better accuracy.
- Extend the design for 3D distance calculations (Pythagorean theorem in 3D).

### Author: KARTHIK A V,NANDANA S BABU,JOEL JOB

