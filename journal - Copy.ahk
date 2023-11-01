; #Notrayicon
#SingleInstance force

#InstallKeybdHook
#InstallMouseHook
Menu, Tray, Icon, %A_WinDir%\system32\shell32.dll, 44
Menu, Tray, NoStandard
Menu, Tray, Add, Reload, reload
Menu, Tray, Add, Exit, closeall

f1:: ;Restart script and clear all variables.
  reload
return

; tray := A_TrayMenu
; A_TrayMenu.Add("Restart", A_MenuHandler4)
; A_MenuHandler4(ItemName, ItemPos, MyMenu) {
;   reload
; }

SetTimer, CheckTime, 60000 ; updates every 1 minute

CheckTime:
  FormatTime, thedate,,dd-MM-yyyy
  IniRead, ActiveTime, track.txt, %thedate%, active, 0
  IniRead, IdleTime, track.txt, %thedate%, idle, 0

  If (A_TimeIdlePhysical < 60000) ; edited this line as per below
    ActiveTime++
  Else
    IdleTime++

  TotalTime := IdleTime + ActiveTime

  IniWrite, %ActiveTime%, track.txt, %thedate%, active
  IniWrite, %IdleTime%, track.txt, %thedate%, idle
  IniWrite, %TotalTime% , track.txt, %thedate%, total

Return

FormatMinutes(NumberOfMinutes) ; Convert mins to hh:mm
{
  Time := 19990101 ; *Midnight* of an arbitrary date
  Time += %NumberOfMinutes%,minutes
  FormatTime, mmss, %time%, H 'h' mm 'min'
Return mmss
}

rctrl::
  Gui, Add, Text, w150 Center, % "Active Time: " FormatMinutes(ActiveTime) "`nIdle Time: " FormatMinutes(IdleTime) "`nTotal: " FormatMinutes(TotalTime)
  Gui, -SysMenu

  Gui, Show
  Keywait,RCtrl, D
  Keywait,RCtrl
  Gui, Destroy
Return

closeall:
ExitApp

reload:
  Reload

