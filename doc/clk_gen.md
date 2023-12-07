# clk_gen

## module diagram

![](E:\IC_design\Verilog\FPGA_S6\freq_meter\doc\clk_gen_module.png)

## signals

|  signal  | width(bit) |  type  |     function      |
| :------: | :--------: | :----: | :---------------: |
|  RESET   |     1      | input  |    ~sys_rst_n     |
| CLK_IN1  |     1      | input  |      sys_clk      |
| CLK_OUT2 |     1      | output |  sys_clk(50Mhz)   |
| CLK_OUT1 |     1      | output | clk_stand(100Mhz) |

