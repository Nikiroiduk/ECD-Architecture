@echo off
if exist %1\%2.exe del %1\%2.exe
MASM_SDK\ml.exe /c %1\%2.asm 
@REM MASM_SDK\link.exe /libpath:F:\ASM\ECD-Architecture\MASM_SDK /subsystem:%3 %2.obj
MASM_SDK\link.exe /defaultlib:MASM_SDK\kernel32.Lib /defaultlib:MASM_SDK\User32.Lib /defaultlib:MASM_SDK\Gdi32.Lib /defaultlib:MASM_SDK\ComDlg32.Lib /subsystem:%3 %2.obj
if exist %2.obj del %2.obj
if not exist %2.exe exit
move %2.exe %1\
%1\%2.exe