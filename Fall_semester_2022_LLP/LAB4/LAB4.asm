; Variant #5
; Ввести строку. Найти слово, стоящее в тексте под третьим номером,
; вывести его первую букву и количество букв в нем.

.686p
.model flat, stdcall
option casemap : none

GetStdHandle proto :dword 
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword
lpBuffer proto :dword, :dword, :dword, :dword
ExitProcess proto :dword 

.data
    message db "Hello World!", 0DH, 0AH
    lmessage equ $ - message
.data?
    consoleOutHandle dd ? 
    bytesWritten dd ? 
.const
    STD_OUTPUT_HANDLE equ -11 

.code
lab4:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov consoleOutHandle, eax 
    invoke WriteConsoleA, \
           consoleOutHandle, \
           offset message, \
           lmessage, \
           offset bytesWritten, \
           0
    invoke ExitProcess, 0 
end lab4