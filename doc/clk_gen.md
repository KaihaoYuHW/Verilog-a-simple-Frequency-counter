# clk_gen

## module diagram

![clk_gen_module](https://github.com/KaihaoYuHW/Verilog_a_simple_Frequency_counter/blob/main/doc/clk_gen_module.png)

## signals

|  signal  | width(bit) |  type  |     function      |
| :------: | :--------: | :----: | :---------------: |
|  RESET   |     1      | input  |    ~sys_rst_n     |
| CLK_IN1  |     1      | input  |      sys_clk      |
| CLK_OUT2 |     1      | output |  sys_clk(50Mhz)   |
| CLK_OUT1 |     1      | output | clk_stand(100Mhz) |

