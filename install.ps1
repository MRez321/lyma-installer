$ErrorActionPreference = "Stop"
Write-Host "lyma-docker Local Installer"
Write-Host "-------------------------------"

Write-Host "Please enter your Nexus credentials in the popup window..."
$cred = Get-Credential -Message "Nexus Authentication"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $cred.UserName, $cred.GetNetworkCredential().Password)))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$LatestUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/latest.txt"
$Version = (Invoke-RestMethod -Uri $LatestUrl -Headers $headers).Trim()
$NexusUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$Version/lyma-docker-$Version.zip"

$ActiveLink = ".\lyma-docker"
$ZipPath = "$env:TEMP\lyma-docker-local.zip"

Write-Host "Downloading v$Version to current directory..."
Invoke-WebRequest -Uri $NexusUrl -Headers $headers -OutFile $ZipPath

if (Test-Path $ActiveLink) { Remove-Item -Recurse -Force $ActiveLink }
Expand-Archive -Path $ZipPath -DestinationPath ".\temp_extract" -Force
Remove-Item $ZipPath

Move-Item ".\temp_extract\lyma-docker-$Version" -Destination $ActiveLink
Remove-Item ".\temp_extract" -Recurse -Force

Write-Host "Successfully extracted to $(Resolve-Path $ActiveLink)"
