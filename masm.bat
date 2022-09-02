@echo off
MASM_SDK\ml.exe /c %1\%2.asm
MASM_SDK\link.exe /DEFAULTLIB:MASM_SDK\kernel32.Lib /DEFAULTLIB:MASM_SDK\User32.Lib /DEFAULTLIB:MASM_SDK\Gdi32.Lib /SUBSYSTEM:WINDOWS %2.obj
if exist %2.obj del %2.obj
move %2.exe %1\
%1\%2.exe