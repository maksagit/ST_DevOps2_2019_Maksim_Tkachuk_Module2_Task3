### 1.3.1. Организовать запуск скрипта каждые 10 минут

[CmdletBinding()]
Param
(
    [string]$NameScript = "Запуск PowerShell скрипта каждые 10 минут",
    [string]$RepeatTime = "00:10:00",                                                                           # Интервал повторения скрипта
    [parameter(Mandatory = $true, HelpMessage = "Введите путь к скрипту PowerShell")]
    [string]$Path                                                                                               # Путь к запускаемому скрипту PowerShell
    #[string]$Path = "C:\git\ST_DevOps2_2019_Maksim_Tkachuk_Module2_Task3\1.3.ps1"                              # Путь к запускаемому скрипту PowerShell

)
$Interval = New-JobTrigger -RepetitionInterval $RepeatTime -RepetitionDuration ([timespan]::MaxValue) `
            -At (Get-Date -DisplayHint Time) -Once                                                              # Интервал
$NewSchJobOption = New-ScheduledJobOption -RunElevated                                                          # Запуск с привилегиями
Register-ScheduledJob -Name $NameScript -FilePath $Path -Trigger $Interval -ScheduledJobOption $NewSchJobOption # Запуск скрипта в планировщике

# Unregister-ScheduledJob "Запуск PowerShell скрипта каждые 10 минут"                                           # Удаление задания в планировщике