import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
import math

@cocotb.test()
async def test_sqrt(dut):
    """Test square root calculation for various input pairs"""
    
    # Create clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset module
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    
    # Test cases
    test_vectors = [
        (3, 4, 5),    # 3^2 + 4^2 = 25, sqrt(25) = 5
        (5, 12, 13),  # 5^2 + 12^2 = 169, sqrt(169) = 13
        (8, 15, 17),  # 8^2 + 15^2 = 289, sqrt(289) = 17
        (7, 24, 25),  # 7^2 + 24^2 = 625, sqrt(625) = 25
    ]
    
    for x, y, expected in test_vectors:
        # Start calculation
        dut.ui_in.value = x
        dut.uio_in.value = y
        dut.ena.value = 1
        await RisingEdge(dut.clk)
        dut.ena.value = 0
        
        # Wait for calculation to complete (max 20 cycles)
        for _ in range(20):
            await RisingEdge(dut.clk)
            if dut.uo_out.value != 0:
                break
        
        # Check result
        actual = dut.uo_out.value.integer
        assert actual == expected, f"For inputs ({x},{y}): Expected {expected}, got {actual}"
