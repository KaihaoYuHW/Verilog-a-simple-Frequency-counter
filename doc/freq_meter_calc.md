# freq_meter_calc

## module diagram

![freq_meter_calc_module](https://github.com/KaihaoYuHW/Verilog_a_simple_Frequency_counter/blob/main/doc/freq_meter_calc_module.png)

## signals

|         signals         | width(bit) |   type   |                           function                           |
| :---------------------: | :--------: | :------: | :----------------------------------------------------------: |
|         sys_clk         |     1      |  input   |                            50Mhz                             |
|        sys_rst_n        |     1      |  input   |                            reset                             |
|        clk_stand        |     1      |  input   |                            100Mhz                            |
|        clk_test         |     1      |  input   |            unknown frequence of a measured signal            |
|          freq           |     34     |  output  | the frequence of a measeured signal. Under sys_clk, as calc_flag_reg=1, store the value of freg_reg. |
|       cnt_gate_s        |     27     | internal | 0~74_999_999=1.5s, 0~12_499_999=0.25s, 12_500_000~62_499_999=1s |
|         gate_s          |     1      | internal |                        0.25s+1s+0.25s                        |
|         gate_a          |     1      | internal |               under clk_test, gate_a <= gate_s               |
|      cnt_clk_test       |     48     | internal |          under gate=1, count clk_test from 0 to X-1          |
|      cnt_clk_stand      |     48     | internal |         under gate=1, count clk_stand from 0 to Y-1          |
|       gate_a_test       |     1      | internal |           under clk_test, gate_a delay 1 clk cycle           |
| gate_a_test_nedge_flag  |     1      | internal | detect gate_a_test negative edge, and then send a pulse signal. |
|    cnt_clk_test_reg     |     48     | internal |               store cnt_clk_test last value X                |
|      gate_a_stand       |     1      | internal |           under clk_stand, gate_delay 1 clk cycle            |
| gate_a_stand_nedge_flag |     1      | internal | detect gate_a_stand negative edge, and then send a pulse signal. |
|    cnt_clk_stand_reg    |     48     | internal |               store cnt_clk_stand last value Y               |
|        calc_flag        |     1      | internal | under sys_clk, as cnt_gate_s=74_999_998, calc_flag send a pulse signal. It means begin to caculate f~X~. |
|        freg_reg         |     34     | internal |               As calc_flag=1, f~X~ = X*f~s~/Y                |
|      calc_flag_reg      |     1      | internal |            under sys_clk, calc delay 1 clk cycle             |

## waveform

```verilog
	defparam uut.freq_meter_calc_inst.CNT_GATE_S_MAX = 240;	// cnt_gate_s: 0~240=1.5s
	defparam uut.freq_meter_calc_inst.CNT_RISE_MAX = 40;	// cnt_gate_s: 0~40=0.25s
```

![freq_meter_calc_waveform1](https://github.com/KaihaoYuHW/Verilog_a_simple_Frequency_counter/blob/main/doc/freq_meter_calc_waveform1.png)

![freq_meter_calc_waveform2](https://github.com/KaihaoYuHW/Verilog_a_simple_Frequency_counter/blob/main/doc/freq_meter_calc_waveform2.png)

