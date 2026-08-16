#!/bin/bash
set -e

VERSION="0.6.7"
NEXUS_URL="https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$VERSION/lyma-docker-$VERSION.zip"

echo "lyma-docker Installer v$VERSION"
echo "-------------------------------"

# Securely prompt for credentials
read -p "Enter your Nexus Username: " NEXUS_USER
read -s -p "Enter your Nexus User Token: " NEXUS_TOKEN
echo "" # Add a newline after the hidden token input

INSTALL_ROOT="$HOME/.lyma"
VERSION_DIR="$INSTALL_ROOT/$VERSION"
ACTIVE_LINK="$INSTALL_ROOT/lyma-docker"

echo "Authenticating and downloading..."

# Clean up previous installs of this specific version
rm -rf "$VERSION_DIR"
mkdir -p "$VERSION_DIR"

# Download using the prompted credentials
# If credentials are wrong, curl fails and set -e kills the script
curl -fsSL -u "$NEXUS_USER:$NEXUS_TOKEN" "$NEXUS_URL" -o "/tmp/lyma.zip"

echo "Extracting..."
unzip -q "/tmp/lyma.zip" -d "$VERSION_DIR"
rm "/tmp/lyma.zip"

# Create the symlink
ln -sfn "$VERSION_DIR" "$ACTIVE_LINK"

echo "Successfully installed to $ACTIVE_LINK"
