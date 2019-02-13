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

function Out ($Data, [System.ConsoleColor]$Color)                                 # Функция вывода
{
    foreach ($i in $Data)
    {
        Write-Host($i) -ForegroundColor $Color
    }
}

Out -data $DataSecurityUpdates -color "Green"
Out -data $DataReg -color "Yellow"