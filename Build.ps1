# ------------------------------------------------------------------------------
# Variables: Paths/Arguments
# ------------------------------------------------------------------------------
$vsEdition = 'Community' # Community | Enterprise | Professional
$pathMsBuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\$vsEdition\MSBuild\15.0\Bin\MSBuild.exe"
$argClean = '/t:Clean'
$argBuild = '/t:Build'
$argMaxCpu = '/m'
$argNodeReuse = '/nr:false'
$argDeployOnBuild = '/p:DeployOnBuild=true'
$argPublishProfile = '/p:PublishProfile='
$argPublishProfileValue = 'LocalFileSystem'
$pathNuGet = "$PSScriptRoot\nuget.exe"
$argRestore = 'restore'
$pathSln = "$PSScriptRoot\LocalNuGet.sln"
$pathPublishProfile = "$PSScriptRoot\LocalNuGet\Properties\PublishProfiles\$argPublishProfileValue.pubxml"
$pathCsProj = "$PSScriptRoot\LocalNuGet\LocalNuGet.csproj"
$horizontalLine = "-" * 78
# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------
Write-Host "+$horizontalLine+" -ForegroundColor Black -BackgroundColor White
Write-Host '| The current script restores nuget packages, cleans, builds, publish solution |' -ForegroundColor Black -BackgroundColor White
Write-Host "+$horizontalLine+" -ForegroundColor Black -BackgroundColor White
# ------------------------------------------------------------------------------
# Validate paths
# ------------------------------------------------------------------------------
if (!(Test-Path $pathMsBuild)) {
    Write-Host "MSBuild (VS2017) not found at ""$pathMsBuild""" -ForegroundColor Red -NoNewline
    Read-Host
    exit
}
if (!(Test-Path $pathNuGet)) {
    Write-Host "NuGet (command-line util) not found at ""$pathNuGet""" -ForegroundColor Red -NoNewline
    Read-Host
    exit
}
if (!(Test-Path $pathSln)) {
    Write-Host "Solution not found at ""$pathSln""" -ForegroundColor Red -NoNewline
    Read-Host
    exit
}
if (!(Test-Path $pathCsProj)) {
    Write-Host "Project not found at ""$pathCsProj""" -ForegroundColor Red -NoNewline
    Read-Host
    exit
}
if (!(Test-Path $pathPublishProfile)) {
    Write-Host "Publish Profile not found at ""$pathPublishProfile""" -ForegroundColor Red -NoNewline
    Read-Host
    exit
}

# ------------------------------------------------------------------------------
# Restore nuget packages
# ------------------------------------------------------------------------------
Write-Host "-$horizontalLine-" -ForegroundColor White
Write-Host 'Restoring packages for solution...' -ForegroundColor Cyan
Start-Process $pathNuGet -ArgumentList $argRestore, """$pathSln""" -Wait -NoNewWindow -ErrorAction Stop
Write-Host 'Packages for solution restored.' -ForegroundColor Green
# ------------------------------------------------------------------------------
# Clean solution
# ------------------------------------------------------------------------------
Write-Host "-$horizontalLine-" -ForegroundColor White
Write-Host 'Cleaning solution...' -ForegroundColor Cyan
Start-Process $pathMsBuild -ArgumentList $argClean, $argMaxCpu, $argNodeReuse, """$pathSln""" -Wait -NoNewWindow -ErrorAction Stop
Write-Host 'Solution clean.' -ForegroundColor Green
# ------------------------------------------------------------------------------
# Build solution
# ------------------------------------------------------------------------------
Write-Host "-$horizontalLine-" -ForegroundColor White
Write-Host 'Building solution...' -ForegroundColor Cyan
Start-Process $pathMsBuild -ArgumentList $argBuild, $argMaxCpu, $argNodeReuse, """$pathSln""" -Wait -NoNewWindow -ErrorAction Stop
Write-Host 'Solution built.' -ForegroundColor Green
# ------------------------------------------------------------------------------
# Publish
# ------------------------------------------------------------------------------
Write-Host "-$horizontalLine-" -ForegroundColor White
Write-Host "Publishing ($argPublishProfileValue)..." -ForegroundColor Cyan
$argPublishProfile += $argPublishProfileValue
Start-Process $pathMsBuild -ArgumentList $argDeployOnBuild, $argPublishProfile, $argNodeReuse, """$pathCsProjWebApi""" -Wait -NoNewWindow -ErrorAction Stop
Write-Host "$argPublishProfileValue published." -ForegroundColor Green
# ------------------------------------------------------------------------------
# Exit
# ------------------------------------------------------------------------------
Write-Host "-$horizontalLine-" -ForegroundColor White
Write-Host "Press <enter> key to exit..." -ForegroundColor DarkGray -NoNewline
Read-Host