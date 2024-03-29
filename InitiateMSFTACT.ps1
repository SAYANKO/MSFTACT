# Check the instructions here on how to use it 

$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/SAYANKO/MSFTACT/main/MSFT_ACT/MSFT_Act.cmd'
$DownloadURL2 = 'https://raw.githubusercontent.com/SAYANKO/MSFTACT/main/MSFT_ACT/MSFT_Act.cmd'

$rand = Get-Random -Maximum 99999999
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MSFTACT_$rand.cmd" } else { "$env:TEMP\MSFTACT_$rand.cmd" }

try {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $DownloadURL2 -UseBasicParsing
}

$ScriptArgs = "$args "
$prefix = "@REM $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\MSFTACT*.cmd", "$env:SystemRoot\Temp\MSFTACT*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
