### 1.3. Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.

[CmdletBinding()]
Param
(
    [string]$NameFolder = "TKACHUK",
    [string]$Root = "C:\",
    [string]$NameFile = "Processes.txt",
    [string]$RootNameFolder = $Root + $NameFolder,                            # Сохранение пути в переменную
    [string]$RootNameFolderNameFile = $Root + $NameFolder + "\" +  $NameFile  # Сохранение пути в переменную
)
if (Test-Path $RootNameFolder)                                                # Удаление папки, если она существует
{
   Remove-Item -Path $RootNameFolder -Force -Recurse                          # Удаляем существующую папку
}
New-Item -Path $Root -Name $NameFolder -ItemType "Directory"                  # Создание папки
Get-Process | Sort-Object UserProcessorTime -Descending -ErrorAction SilentlyContinue | `
Select-Object Name, Id, UserProcessorTime -First 10 > $RootNameFolderNameFile # список из 10 процессов занимающих дольше всего процессор
Get-Content $RootNameFolderNameFile                                           # Извлекаем данные из файла и отображаем в консоли

# Remove-Item -Path $RootNameFolder  -Force -Recurse                          # Удаление папки