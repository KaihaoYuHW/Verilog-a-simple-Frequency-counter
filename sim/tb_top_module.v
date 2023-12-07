`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:24:23 12/06/2023
// Design Name:   top_module
// Module Name:   E:/IC_design/Verilog/FPGA_S6/freq_meter/sim/tb_top_module.v
// Project Name:  freq_meter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top_module;

	// Inputs
	reg sys_clk;
	reg sys_rst_n;
	reg clk_test;

	// Outputs
	wire [33:0] freq;

	// Instantiate the Unit Under Test (UUT)
	top_module uut (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.clk_test(clk_test),
		.freq(freq)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		#200;
		sys_rst_n <= 1'b1;
		#500;
		clk_test = 1'b1;
	end

	always #100 clk_test = ~clk_test;
	always #10 sys_clk = ~sys_clk;

	defparam uut.freq_meter_calc_inst.CNT_GATE_S_MAX = 240;
	defparam uut.freq_meter_calc_inst.CNT_RISE_MAX = 40;

endmodule

