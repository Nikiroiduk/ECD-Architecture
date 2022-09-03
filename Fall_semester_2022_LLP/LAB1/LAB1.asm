.686p
.model flat, stdcall
option casemap : none
ExitProcess PROTO STDCALL :DWORD
MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD

.data
TextMsg db 'This is the first programm for Win32',0
TitleMsg db 'Asm language Masm32!',0
.const
MB_OK equ 0

.code
lab1:
push MB_OK
push offset TitleMsg
push offset TextMsg
push 0
call MessageBoxA
push 0
call ExitProcess
end lab1