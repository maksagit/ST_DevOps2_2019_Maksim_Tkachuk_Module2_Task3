### 1.5. Создать один скрипт, объединив 3 задачи:
### 1.5.1. Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.

[CmdletBinding()]
Param
(
    [string]$Root = "C:\",
    
    [parameter(Mandatory = $true, HelpMessage = "Введите имя папки:")]
    [string]$NameFolder,

    [string]$NameFileCSV = "SecurityUpdates.csv",
    [string]$NameFileXML = "HKLM_SOFTWARE_Microsoft.xml",
    [string]$RootNameFolder = $Root + $NameFolder,                                   # Сохранение пути в переменную
    [string]$RootNameFolderNameFileCSV = $Root + $NameFolder + "\" + $NameFileCSV,   # Сохранение пути в переменную
    [string]$RootNameFolderNameFileXML = $Root + $NameFolder + "\" +  $NameFileXML   # Сохранение пути в переменную
)

if (Test-Path $RootNameFolder)                                                       # Удаление папки, если она существует
{
    Remove-Item -Path $RootNameFolder -Recurse -Confirm
}
New-Item -Path $Root -Name $NameFolder -ItemType Directory                           # Создание папки
foreach ($i in Get-HotFix | Select-Object Description, HotFixID, InstalledBy, InstalledOn, PSComputerName)
{
    if ($i.Description -eq "Security Update")
    {
        $i | Export-Csv -Path $RootNameFolderNameFileCSV -NoTypeInformation -Append  # Запись информации об обновлениях безопасности в CSV
        #$i | Out-File -Append -FilePath  $Root$NameFolder"\"$NameFileCSV
    }
} 

### 1.5.2. Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.

Get-ChildItem -LiteralPath HKLM:\SOFTWARE\Microsoft | Export-Clixml -Path $RootNameFolderNameFileXML
#Get-ChildItem -LiteralPath HKLM:\SOFTWARE\Microsoft > $RootNameFolderNameFileXML

### 1.5.3. Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка разным разными цветами

$DataSecurityUpdates = Get-Content -Path $RootNameFolderNameFileCSV               # Читаем .csv файл
$DataReg = Get-Content -Path $RootNameFolderNameFileXML                           # Читаем .xml файл

function OutColor ($Data, [System.ConsoleColor]$Color)                            # Функция вывода
{
    foreach ($i in $Data)
    {
        Write-Host($i) -ForegroundColor $Color
    }
}

OutColor -data $DataSecurityUpdates -color "Green"
OutColor -data $DataReg -color "Yellow"