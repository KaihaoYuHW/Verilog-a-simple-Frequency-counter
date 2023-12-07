module top_module (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire clk_test,
    output wire [33:0] freq
    // output wire [5:0] sel,
    // output wire [7:0] seg
);

    wire CLK_OUT2_sys_clk;
    wire CLK_OUT1_clk_stand;
    wire CLK_OUT3_clk_test;
    // wire [33:0] freq_data;
    
    clk_gen clk_gen_inst (
        .RESET (~sys_rst_n),
        .CLK_IN1 (sys_clk),
        .CLK_OUT1 (CLK_OUT1_clk_stand),
        .CLK_OUT2 (CLK_OUT2_sys_clk)
        // .CLK_OUT3 (CLK_OUT3_clk_test)
    );

    freq_meter_calc freq_meter_calc_inst (
        .sys_clk (CLK_OUT2_sys_clk),
        .sys_rst_n (sys_rst_n),
        .clk_stand (CLK_OUT1_clk_stand),
        .clk_test (clk_test),
        // .clk_test (CLK_OUT3_clk_test),
        .freq (freq)
    );

    // seg_dynamic seg_dynamic_inst (
    //     .sys_clk (CLK_OUT2_sys_clk),
    //     .sys_rst_n (sys_rst_n),
    //     .data (freq_data/1000),
    //     .point (6'b000000),
    //     .seg_en (1'b1),
    //     .sign (1'b0),
    //     .sel (sel),
    //     .seg (seg)
    // );
    
endmodule