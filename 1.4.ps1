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