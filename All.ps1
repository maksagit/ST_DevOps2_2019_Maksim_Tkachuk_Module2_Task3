### 1.1. Сохранить в текстовый файл на диске список запущенных(!) служб. 
### Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
[CmdletBinding()]
Param 
(
    
    [parameter(Mandatory = $true, HelpMessage = "Введите имя диска:")]
    [string]$NameDisk,
    
    [string]$Root = "C:\",
    
    [parameter(Mandatory = $true, HelpMessage = "Введите имя папки:")]
    [string]$NameFolder,

    [string]$NameFile = "Service.txt"
)
if ((Test-Path $Root$NameFolder"\") -eq "True")                               # Удаление папки, если она существует
{
   Remove-Item -Path $Root$NameFolder -Force -Recurse -Confirm                # Удаляем существующую папку
   Remove-PSDrive -Name $NameDisk -Force                                      # Удаляем существущий диск
}
New-Item -Path $Root -Name $NameFolder -ItemType "Directory"                  # Создание папки
New-PSDrive -Root $Root$NameFolder -Name $NameDisk -PSProvider FileSystem     # Создание диска ассоциированного с папкой
Get-Service | Where-Object {$_.Status -eq 'Running'} > $NameDisk":\"$NameFile # Запись запущенных служб в файл
Get-Content $NameDisk":\"$NameFile                                            # Извлекаем данные из файла и отображаем в консоли

####
#Remove-PSDrive -Name "$NameDisk" -Force                                      # Удаление диска ассоциированного с папкой
#Remove-Item "$Root$NameFolder" -Recurse                                      # Удаление папки

### 1.2. Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
[CmdletBinding()]
Param 
(
    [int]$a = (Get-Random -Maximum 100),
    [int]$b = 13,
    [int]$tmp = 0
)

foreach ($i in (Get-Variable | Select-Object Value))
{ 
    if ($i.Value -is [int])
    {
        $tmp += $i.Value
    }
}
Write-Host("Sum = $tmp") -ForegroundColor Yellow

### 1.3. Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.

[CmdletBinding()]
Param
(
    [string]$NameFolder = "TKACHUK",
    [string]$Root = "C:\",
    [string]$NameFile = "Processes.txt"
)
if ((Test-Path $Root$NameFolder"\") -eq "True")                               # Удаление папки, если она существует
{
   Remove-Item -Path $Root$NameFolder -Force -Recurse                         # Удаляем существующую папку
}
New-Item -Path $Root -Name $NameFolder -ItemType "Directory"                  # Создание папки
Get-Process | Sort-Object UserProcessorTime -Descending -ErrorAction SilentlyContinue | `
Select-Object Name, Id, UserProcessorTime -First 10 > $Root$NameFolder"\"$NameFile # список из 10 процессов занимающих дольше всего процессор
Get-Content $Root$NameFolder"\"$NameFile                                      # Извлекаем данные из файла и отображаем в консоли

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

### 1.4. Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)

[CmdletBinding()]
Param 
(
    [parameter (Mandatory = $true, HelpMessage = "Укажите папку для которой нужно посчитать занимаемый ею размер: ")]
    [string]$DirectoryPath ,                           # "C:\Windows\"

    [parameter (Mandatory = $true, HelpMessage = "Укажите исключаемые из подсчета расширения файлов: (tmp, jpg, log ...)")]
    [string]$ExcludeType,                              # Расширение

    [int]$Total = 0
)

$FilesArrayLength = @(Get-ChildItem -Path $DirectoryPath -Recurse -file -Exclude "*.$ExcludeType" -ErrorAction SilentlyContinue | Select-Object Length)
foreach ($i in $FilesArrayLength)
{
    $Total += ($i.Length/1MB)                         # Размер занимаемый файлами в папке
}
Write-Output("Total: " + $Total + " MB")

### 1.5. Создать один скрипт, объединив 3 задачи:
### 1.5.1. Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.

[CmdletBinding()]
Param
(
    [string]$Root = "C:\",
    
    [parameter(Mandatory = $true, HelpMessage = "Введите имя папки:")]
    [string]$NameFolder,

    [string]$NameFileCSV = "SecurityUpdates.csv",
    [string]$NameFileXML = "HKLM_SOFTWARE_Microsoft.xml"
)

if ((Test-Path $Root$NameFolder) -eq "True")                                             # Удаление папки, если она существует
{
    Remove-Item -Path $Root$NameFolder -Recurse -Confirm
}
New-Item -Path $Root -Name $NameFolder -ItemType Directory                               # Создание папки
foreach ($i in Get-HotFix | Select-Object Description, HotFixID, InstalledBy, InstalledOn, PSComputerName)
{
    if ($i.Description -eq "Security Update")
    {
        $i | Export-Csv -Path $Root$NameFolder"\"$NameFileCSV -NoTypeInformation -Append # Запись информации об обновлениях безопасности в CSV
        #$i | Out-File -Append -FilePath  $Root$NameFolder"\"$NameFileCSV
    }
} 

### 1.5.2. Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.

Get-ChildItem -LiteralPath HKLM:\SOFTWARE\Microsoft | Export-Clixml -Path $Root$NameFolder"\"$NameFileXML
#Get-ChildItem -LiteralPath HKLM:\SOFTWARE\Microsoft > $Root$NameFolder"\"$NameFileXML

### 1.5.3. Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка разным разными цветами

$DataSecurityUpdates = Get-Content -Path $Root$NameFolder"\"$NameFileCSV          # Читаем .csv файл
$DataReg = Get-Content -Path $Root$NameFolder"\"$NameFileXML                      # Читаем .xml файл

function OutColor ($Data, [System.ConsoleColor]$Color)                            # Функция вывода
{
    foreach ($i in $Data)
    {
        Write-Host($i) -ForegroundColor $Color
    }
}

OutColor -data $DataSecurityUpdates -color "Green"
OutColor -data $DataReg -color "Yellow"

### 2. Работа с профилем
### 2.1. Создать профиль

New-Item -Path $profile -ItemType "File" -Force   # Создаем профиль

### 2.2. В профиле изменить цвета в консоли PowerShell

psedit $profile  # Открываем профиль и вставляем весь текст, который ниже в пунктах 2=====>
#=========================================================================================

(Get-Host).UI.RawUI.ForegroundColor = "Green"
(Get-Host).UI.RawUI.BackgroundColor = "Black"

### 2.3. Создать несколько собственный алиасов

Set-Alias MyHelp Get-Help
Set-Alias MyAlias Get-Alias

### 2.4. Создать несколько констант

Set-Variable x13 -Option Constant -Value 13
#$x13
Set-Variable pi -Option Constant -Value 3.14
#$pi

### 2.5. Изменить текущую папку

[string]$Root = "C:\"
[string]$NameFolder = "MAKSIM_TKACHUK"
if ((Test-Path $Root$NameFolder"\") -ne "True")                         # Проверка на наличие и смена папки
{  
   New-Item -Path $Root -Name $NameFolder -ItemType "Directory"
   Set-Location $Root$NameFolder  
}
else {
   Set-Location $Root$NameFolder                                        # Меняем текущую папку
}

### 2.6. Вывести приветсвие

Write-Host("Добро пожаловать в PowerShell!") -ForegroundColor red

### 2.7. Проверить применение профиля

Write-Host ("Проверка alias - MyHelp") -ForegroundColor red
MyHelp -Examples
Write-Host ("Это моя константа: $pi") -ForegroundColor red
$pi

### 3. Получить список всех доступных модулей

Get-Module -ListAvailable -All