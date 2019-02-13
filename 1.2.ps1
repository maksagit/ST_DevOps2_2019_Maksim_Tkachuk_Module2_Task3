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