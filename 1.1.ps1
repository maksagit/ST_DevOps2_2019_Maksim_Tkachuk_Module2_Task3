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

    [string]$NameFile = "Service.txt",
    [string]$PathDiskFile = $NameDisk + ":\" + $NameFile,                     # Сохранение пути в переменную
    [string]$PathRootNameFolder = $Root + $NameFolder                         # Сохранение пути в переменную
)

if (Test-Path $PathRootNameFolder)                                            # Удаление папки, если она существует
{
   Remove-Item -Path $PathRootNameFolder  -Force -Recurse -Confirm            # Удаляем существующую папку
   Remove-PSDrive -Name $NameDisk -Force                                      # Удаляем существущий диск
}
New-Item -Path $Root -Name $NameFolder -ItemType "Directory"                  # Создание папки
New-PSDrive -Root $PathRootNameFolder -Name $NameDisk -PSProvider FileSystem  # Создание диска ассоциированного с папкой                                               # Сохраним путь к файлу в переменную
Get-Service | Where-Object {$_.Status -eq 'Running'} > $PathDiskFile          # Запись запущенных служб в файл
Get-Content $PathDiskFile                                                     # Извлекаем данные из файла и отображаем в консоли

####
#Remove-PSDrive -Name $NameDisk -Force                                        # Удаление диска ассоциированного с папкой
#Remove-Item -Path $PathRootNameFolder  -Force -Recurse                       # Удаление папки