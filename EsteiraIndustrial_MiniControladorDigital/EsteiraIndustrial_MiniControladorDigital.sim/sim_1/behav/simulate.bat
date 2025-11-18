@echo off
set xv_path=D:\\Vivado\\2015.1\\bin
call %xv_path%/xsim tb_controlador_esteira_behav -key {Behavioral:sim_1:Functional:tb_controlador_esteira} -tclbatch tb_controlador_esteira.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
