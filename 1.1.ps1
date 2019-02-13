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