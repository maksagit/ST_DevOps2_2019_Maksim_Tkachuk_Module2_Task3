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