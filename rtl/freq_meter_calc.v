module freq_meter_calc (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire clk_test,
    input wire clk_stand,
    output reg [33:0] freq
);
    
    parameter CNT_GATE_S_MAX = 27'd74_999_999;  // 1.5s
    parameter CNT_RISE_MAX = 27'd12_500_000;    // 0.25s
    parameter CLK_STAND_FREQ = 28'D100_000_000; // freq of clk_stand = 100Mhz
    
    wire gate_a_test_nedge_flag;
    wire gate_a_stand_nedge_flag;

    reg [26:0] cnt_gate_s;
    reg gate_s;
    reg gate_a;
    reg [47:0] cnt_clk_test;
    reg [47:0] cnt_clk_stand;
    reg gate_a_test;
    reg [47:0] cnt_clk_test_reg;
    reg gate_a_stand;
    reg [47:0] cnt_clk_stand_reg;
    reg calc_flag;
    reg [33:0] freq_reg;
    reg calc_flag_reg;

    // cnt_gate_s: 1.5s = count 0 to 74_999_999
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            cnt_gate_s <= 27'd0;
        else if (cnt_gate_s == CNT_GATE_S_MAX)
            cnt_gate_s <= 27'd0;
        else
            cnt_gate_s <= cnt_gate_s + 1'b1;
    end

    // gate_s: 0.25s(low) + 1s(high) + 0.25s(low)
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            gate_s <= 1'b0;
        else if ((cnt_gate_s >= CNT_RISE_MAX) && (cnt_gate_s <= (CNT_GATE_S_MAX - CNT_RISE_MAX)))
            gate_s <= 1'b1;
        else 
            gate_s <= 1'b0;
    end

    // gate_a
    always @(posedge clk_test or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            gate_a <= 1'b0;
        else 
            gate_a <= gate_s;
    end

    // cnt_clk_test: count clk_test from 0 to X-1
    always @(posedge clk_test or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            cnt_clk_test <= 48'd0;
        else if (gate_a == 1'b1)
            cnt_clk_test <= cnt_clk_test + 1'b1;
        else
            cnt_clk_test <= 48'd0;
    end

    // cnt_clk_stand: count clk_stand from 0 to Y-1
    always @(posedge clk_stand or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            cnt_clk_stand <= 48'd0;
        else if (gate_a == 1'b1)
            cnt_clk_stand <= cnt_clk_stand + 1'b1;
        else 
            cnt_clk_stand <= 48'd0;
    end

    // gate_a_test: gate_a under clk_test delay 1 clk cycle
    always @(posedge clk_test or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            gate_a_test <= 1'b0;
        else
            gate_a_test <= gate_a;
    end

    // gate_a_test_nedge_flag: detect the negative edge of gate_a_test
    assign gate_a_test_nedge_flag = ((gate_a_test == 1'b1) && (gate_a == 1'b0)) ? 1'b1 : 1'b0;

    // cnt_clk_test_reg: store cnt_clk_test last value X
    always @(posedge clk_test or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            cnt_clk_test_reg <= 48'd0;
        else if (gate_a_test_nedge_flag == 1'b1)
            cnt_clk_test_reg <= cnt_clk_test + 1'b1;
    end
    
    // gate_a_stand: gate_a under clk_stand delay 1 clk cycle
    always @(posedge clk_stand or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            gate_a_stand <= 1'b0;
        else
            gate_a_stand <= gate_a;
    end

    // gate_a_stand_nedge_flag: detect the negative edge of gate_a_stand
    assign gate_a_stand_nedge_flag = ((gate_a_stand == 1'b1) && (gate_a == 1'b0)) ? 1'b1 : 1'b0;

    // cnt_clk_stand_reg: store cnt_clk_stand last value Y
    always @(posedge clk_stand or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            cnt_clk_stand_reg <= 48'd0;
        else if (gate_a_stand_nedge_flag == 1'b1)
            cnt_clk_stand_reg <= cnt_clk_stand + 1'b1;
    end

    // calc_flag: As cnt_gate_s = 74_999_998, calc_flag send a pulse signal. It means begin to caculate fx
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            calc_flag <= 1'b0;
        else if (cnt_gate_s == CNT_GATE_S_MAX - 1'b1)
            calc_flag <= 1'b1;
        else
            calc_flag <= 1'b0;
    end

    // freq_reg: As calc_flag=1, calculate fx
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            freq_reg <= 34'd0;
        else if (calc_flag == 1'b1)
            freq_reg <= cnt_clk_test_reg * CLK_STAND_FREQ / cnt_clk_stand_reg;
    end

    // calc_flag_reg: calc_flag delay 1 clk cycle
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            calc_flag_reg <= 1'b0;
        else
            calc_flag_reg <= calc_flag;
    end
    
    // freq: output the freq of clk_test
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            freq <= 34'd0;
        else if (calc_flag_reg == 1'b1)
            freq <= freq_reg;
    end

endmodule