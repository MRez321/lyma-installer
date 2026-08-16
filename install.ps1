$ErrorActionPreference = "Stop"

Write-Host "lyma-docker Installer"
Write-Host "-------------------------------"

Write-Host "Please enter your Nexus credentials in the popup window..."
$cred = Get-Credential -Message "Nexus Authentication"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $cred.UserName, $cred.GetNetworkCredential().Password)))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

Write-Host "Checking for latest version..."
$LatestUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/latest.txt"
try {
    $Version = (Invoke-RestMethod -Uri $LatestUrl -Headers $headers).Trim()
} catch {
    Write-Error "Failed to fetch latest version. Check your credentials."
    exit 1
}

$NexusUrl = "https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$Version/lyma-docker-$Version.zip"

$InstallRoot = "$env:LOCALAPPDATA\lyma"
$VersionDir = "$InstallRoot\$Version"
$ActiveLink = "$InstallRoot\lyma-docker"
$ZipPath = "$env:TEMP\lyma-docker.zip"

Write-Host "Downloading v$Version..."
if (Test-Path $VersionDir) { Remove-Item -Recurse -Force $VersionDir }
New-Item -ItemType Directory -Force -Path $VersionDir | Out-Null

Invoke-WebRequest -Uri $NexusUrl -Headers $headers -OutFile $ZipPath

Write-Host "Extracting..."
Expand-Archive -Path $ZipPath -DestinationPath $VersionDir -Force
Remove-Item $ZipPath

# git archive wraps files in lyma-docker-$Version\
$ActualDir = "$VersionDir\lyma-docker-$Version"

if (Test-Path $ActiveLink) { cmd /c rmdir "$ActiveLink" }
cmd /c mklink /J "$ActiveLink" "$ActualDir" | Out-Null

$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($CurrentPath -notlike "*$ActiveLink*") {
    [Environment]::SetEnvironmentVariable("Path", "$CurrentPath;$ActiveLink", "User")
    $env:Path += ";$ActiveLink"
    Write-Host "Added $ActiveLink to your User PATH."
}

Write-Host "Successfully installed v$Version. Open a new terminal to use it."
