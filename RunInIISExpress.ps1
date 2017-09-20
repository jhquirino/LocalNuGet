# ------------------------------------------------------------------------------
# Variables: Paths/Arguments
# ------------------------------------------------------------------------------
$pathIISExpress = 'C:\Program Files\IIS Express\iisexpress.exe'
$argPath = '/path:'
$argPathValue = "$PSScriptRoot\PublishOutput"
$argPort = '/port:'
$argPortValue = '54001'
$urlTest = "http://localhost:$argPortValue/"
# ------------------------------------------------------------------------------
# Validate paths
# ------------------------------------------------------------------------------
if (!(Test-Path -Path $pathIISExpress)) {
    Write-Host "IIS Express not found at ""$pathIISExpress""." -ForegroundColor Red -NoNewline
    Read-Host
    exit
}
if (!(Test-Path -Path $argPathValue)) {
    Write-Host "Publish not found at ""$pathIISExpress""." -ForegroundColor Red -NoNewline
    Read-Host
    exit
}
# ------------------------------------------------------------------------------
# Execute
# ------------------------------------------------------------------------------
$argPath += """$argPathValue"""
$argPort += $argPortValue
#Write-Host "& '$pathIISExpress' $argPath $argPort" -ForegroundColor DarkGray
Write-Host "Starting Local NuGet Server from ""$argPathValue"" on port $argPortValue..." -ForegroundColor Cyan
Start-Process $pathIISExpress -ArgumentList $argPath, $argPort -PassThru
Start-Sleep -Seconds 5
Start-Process $urlTest
# ------------------------------------------------------------------------------
# Exit
# ------------------------------------------------------------------------------
Write-Host "Press <enter> key to exit..." -ForegroundColor Yellow -NoNewline
Read-Host