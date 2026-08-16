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
$EnvPath = Join-Path $TargetDir ".env"
$EnvBackup = "$env:TEMP\.env_backup"

Write-Host "Downloading v$Version to current directory..."
Invoke-WebRequest -Uri $NexusUrl -Headers $headers -OutFile $ZipPath

Write-Host "Extracting..."

# Backup .env if it exists
if (Test-Path $EnvPath) {
    Write-Host "Preserving existing .env file..."
    Copy-Item $EnvPath $EnvBackup -Force
}

if (Test-Path $TargetDir) { Remove-Item -Recurse -Force $TargetDir }
Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

# Move the entire extracted folder (including hidden files) to the target directory
Move-Item "$TempDir\lyma-docker-$Version" -Destination $TargetDir -Force

# Restore .env if it was backed up
if (Test-Path $EnvBackup) {
    Move-Item $EnvBackup $EnvPath -Force
}

Remove-Item $ZipPath -Force
Remove-Item $TempDir -Recurse -Force

Write-Host "Successfully extracted to $(Resolve-Path $TargetDir)"
