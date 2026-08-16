#!/bin/bash
set -e

echo "lyma-docker Installer"
echo "-------------------------------"

read -p "Enter your Nexus Username: " NEXUS_USER
read -s -p "Enter your Nexus User Token: " NEXUS_TOKEN
echo "" 

echo "Checking for latest version..."
LATEST_URL="https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/latest.txt"
VERSION=$(curl -fsSL -u "$NEXUS_USER:$NEXUS_TOKEN" "$LATEST_URL")
if [ -z "$VERSION" ]; then
  echo "Failed to fetch latest version. Check your credentials."
  exit 1
fi

NEXUS_URL="https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$VERSION/lyma-docker-$VERSION.zip"

INSTALL_ROOT="$HOME/.lyma"
VERSION_DIR="$INSTALL_ROOT/$VERSION"
ACTIVE_LINK="$INSTALL_ROOT/lyma-docker"

echo "Downloading v$VERSION..."
rm -rf "$VERSION_DIR"
mkdir -p "$VERSION_DIR"

curl -fsSL -u "$NEXUS_USER:$NEXUS_TOKEN" "$NEXUS_URL" -o "/tmp/lyma.zip"

echo "Extracting..."
unzip -q "/tmp/lyma.zip" -d "$VERSION_DIR"
rm "/tmp/lyma.zip"

# git archive wraps files in lyma-docker-$VERSION/
ACTUAL_DIR="$VERSION_DIR/lyma-docker-$VERSION"
ln -sfn "$ACTUAL_DIR" "$ACTIVE_LINK"

if [[ ":$PATH:" != *":$ACTIVE_LINK:"* ]]; then
    echo "export PATH=\$PATH:$ACTIVE_LINK" >> "$HOME/.bashrc"
    if [ -f "$HOME/.zshrc" ]; then
        echo "export PATH=\$PATH:$ACTIVE_LINK" >> "$HOME/.zshrc"
    fi
    export PATH=$PATH:$ACTIVE_LINK
    echo "Added $ACTIVE_LINK to your shell profile."
fi

echo "Successfully installed v$VERSION. Open a new terminal to use it."
