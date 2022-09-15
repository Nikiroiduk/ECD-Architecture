; Variant #2
; Используя обработку сообщений WM_KEYDOWN,
; WM_RBUTTONDBLCLK, WM_LBUTTONDBLCLK, WM_TIMER и т.д. и
; API-функции ShowWindow, CloseWindow, MoveWindow, SetWindowText,
; GetWindowTextLength, GetClientRect, GetTitleBarInfo, GetWindowPlacement,
; SetWindowPlacement, WindowFromPoint, AnimateWindow, SetTimer, KillTimer
; и т.д. создать оконное приложение, осуществляющее действия:
; Двойной щелчок левой кнопки в клиентской области окна приводит
; к горизонтальному перемещению окна по экрану. Отменить перемещение
; можно нажатием клавиши F5.

.686p
.model flat, stdcall
option casemap : none

ExitProcess   proto   :dword

.data

.data?

.const

.code
lab5:
    invoke ExitProcess, 0
end lab5