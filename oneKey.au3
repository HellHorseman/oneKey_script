HotKeySet("q", "MyHotKeyFunc")         ; горячяя клавиша запуска Q (подсказка: ^ - Ctrl, ! - Alt, + - Shift, # - Win)
HotKeySet("-", "ResetScript")          ; Горячая клавиша сброса: - (на всякий случай)
$Winamp_Title = "Winamp"
$LightDJ_Title = "Martin LightJockey"
$Cue_Key = "{F1}"                      ; старт/стоп кью
$Volume_Steps = 19                     ; Количество нажатий для увеличения громкости
; ----------------------------------------

Global $g_bIsActive = False
Global $g_hTimer = 0

TrayTip("Для запуска скрипта", "Горячая клавиша: Q" & @CRLF & "Горячая клавиша сброса: -", 5)

While 1
    If $g_bIsActive And TimerDiff($g_hTimer) >=  180000 Then ; 180000 мс = 3 минуты
        RestoreOriginalState()
    EndIf
    Sleep(100)
WEnd

Func MyHotKeyFunc()
    If $g_bIsActive Then
        TrayTip("Уже активно", "Функция уже работает, ожидайте завершения", 2)
        Return
    EndIf

    $g_bIsActive = True

    If WinActivate($Winamp_Title) Then
        WinWaitActive($Winamp_Title)
        Sleep(30)

        For $i = 1 To $Volume_Steps
            Send("^!{UP}")
            Sleep(10)
        Next
    Else
        TrayTip("Ошибка", "Окно Winamp не найдено!", 2)
        $g_bIsActive = False
        Return
    EndIf

	If WinActivate($LightDJ_Title) Then
        WinWaitActive($LightDJ_Title)
        Sleep(30)
        Send($Cue_Key)
    Else
        TrayTip("Предупреждение", "Окно LightDJ не найдено, только громкость изменена", 2)
    EndIf

	$g_hTimer = TimerInit()

	TrayTip("Действие активировано", "Громкость увеличена (" & $Volume_Steps & " шагов)" & @CRLF & "Cue запущен" & @CRLF & "Возврат через 3 минуты", 3)
EndFunc

Func RestoreOriginalState()
    If WinActivate($Winamp_Title) Then
        WinWaitActive($Winamp_Title)
        Sleep(30)

        For $i = 1 To $Volume_Steps
            Send("^!{DOWN}")
            Sleep(10)
        Next
    EndIf

    If WinActivate($LightDJ_Title) Then
        WinWaitActive($LightDJ_Title)
        Sleep(30)
        Send($Cue_Key)
    EndIf

    $g_bIsActive = False

    TrayTip("Возврат выполнен", "Громкость и состояние восстановлены", 3)
EndFunc


Func ResetScript()
    If $g_bIsActive Then
        RestoreOriginalState()
    Else
        TrayTip("Скрипт", "Неактивно, сброс не требуется", 2)
    EndIf
EndFunc
