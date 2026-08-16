$ErrorActionPreference = "Stop"

$Version = "0.6.7"
$NexusUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$Version/lyma-docker-$Version.zip"

Write-Host "lyma-docker Installer v$Version"
Write-Host "-------------------------------"

# Prompt using native Windows UI
Write-Host "Please enter your Nexus credentials in the popup window..."
$cred = Get-Credential -Message "Nexus Authentication"

# Convert credentials to Basic Auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $cred.UserName, $cred.GetNetworkCredential().Password)))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$InstallRoot = "$env:LOCALAPPDATA\lyma"
$VersionDir = "$InstallRoot\$Version"
$ActiveLink = "$InstallRoot\lyma-docker"
$ZipPath = "$env:TEMP\lyma-docker-$Version.zip"

Write-Host "Authenticating and downloading..."

if (Test-Path $VersionDir) { Remove-Item -Recurse -Force $VersionDir }
New-Item -ItemType Directory -Force -Path $VersionDir | Out-Null

# Download using the prompted credentials
Invoke-WebRequest -Uri $NexusUrl -Headers $headers -OutFile $ZipPath

Write-Host "Extracting..."
Expand-Archive -Path $ZipPath -DestinationPath $VersionDir -Force
Remove-Item $ZipPath

# Create the directory junction
if (Test-Path $ActiveLink) { cmd /c rmdir "$ActiveLink" }
cmd /c mklink /J "$ActiveLink" "$VersionDir" | Out-Null

Write-Host "Successfully installed to $ActiveLink"
