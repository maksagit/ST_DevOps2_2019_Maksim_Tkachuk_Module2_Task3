### 2. Работа с профилем
### 2.1. Создать профиль

New-Item -Path $profile -ItemType "File" -Force   # Создаем профиль

### 2.2. В профиле изменить цвета в консоли PowerShell

psedit $profile  # Открываем профиль и вставляем весь текст, который ниже в пунктах 2=====>
#========================================================================================

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
[string]$RootNameFolder = $Root + $NameFolder                           # Сохранение пути в переменную
if ((Test-Path $RootNameFolder) -ne "True")                             # Проверка на наличие и смена папки
{  
   New-Item -Path $Root -Name $NameFolder -ItemType "Directory"
   Set-Location $RootNameFolder 
}
else {
   Set-Location $RootNameFolder                                         # Меняем текущую папку
}

### 2.6. Вывести приветсвие

Write-Host("Добро пожаловать в PowerShell!") -ForegroundColor red

### 2.7. Проверить применение профиля

Write-Host ("Проверка alias - MyHelp") -ForegroundColor red
MyHelp -Examples
Write-Host ("Это моя константа: $pi") -ForegroundColor red
$pi