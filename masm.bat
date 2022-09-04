@echo off
if exist %1\%2.exe del %1\%2.exe
MASM_SDK\ml.exe /c %1\%2.asm 
MASM_SDK\link.exe /DEFAULTLIB:MASM_SDK\kernel32.Lib /DEFAULTLIB:MASM_SDK\User32.Lib /DEFAULTLIB:MASM_SDK\Gdi32.Lib /DEFAULTLIB:MASM_SDK\ComDlg32.Lib /SUBSYSTEM:WINDOWS %2.obj
if exist %2.obj del %2.obj
if not exist %2.exe exit
move %2.exe %1\
%1\%2.exe