$ErrorActionPreference = "Stop"

Write-Host "lyma-docker Installer"
Write-Host "-------------------------------"

Write-Host "Please enter your Nexus credentials in the popup window..."
$cred = Get-Credential -Message "Nexus Authentication"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $cred.UserName, $cred.GetNetworkCredential().Password)))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$LatestUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/latest.txt"
$Version = (Invoke-RestMethod -Uri $LatestUrl -Headers $headers).Trim()
$NexusUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$Version/lyma-docker-$Version.zip"

$TargetDir = ".\lyma-docker"
$TempDir = "$env:TEMP\lyma_extract"
$ZipPath = "$env:TEMP\lyma.zip"

Write-Host "Downloading v$Version to current directory..."
Invoke-WebRequest -Uri $NexusUrl -Headers $headers -OutFile $ZipPath

Write-Host "Extracting..."
if (Test-Path $TargetDir) { Remove-Item -Recurse -Force $TargetDir }
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

# Move contents of the nested git archive folder directly into .\lyma-docker
Move-Item "$TempDir\lyma-docker-$Version\*" -Destination $TargetDir -Force

Remove-Item $ZipPath -Force
Remove-Item $TempDir -Recurse -Force

Write-Host "Successfully extracted to $(Resolve-Path $TargetDir)"
