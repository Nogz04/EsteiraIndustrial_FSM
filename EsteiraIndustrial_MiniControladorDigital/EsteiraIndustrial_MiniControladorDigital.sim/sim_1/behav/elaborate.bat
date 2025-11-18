@echo off
set xv_path=D:\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto c374cf6eaa3b4f36966be59389446c9c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_controlador_esteira_behav xil_defaultlib.tb_controlador_esteira -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
