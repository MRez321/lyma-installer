#!/bin/bash
set -e

echo "lyma-docker Installer"
echo "-------------------------------"

read -p "Enter your Nexus Username: " NEXUS_USER
read -s -p "Enter your Nexus User Token: " NEXUS_TOKEN
echo ""

LATEST_URL="https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/latest.txt"
VERSION=$(curl -fsSL -u "$NEXUS_USER:$NEXUS_TOKEN" "$LATEST_URL")
if [ -z "$VERSION" ]; then
  echo "Failed to fetch latest version. Check your credentials."
  exit 1
fi

NEXUS_URL="https://repo.lymagroups.ir/repository/lyma-raw-hosted/lyma-docker/$VERSION/lyma-docker-$VERSION.zip"
TARGET_DIR="./lyma-docker"
TEMP_ZIP="/tmp/lyma.zip"
TEMP_DIR="/tmp/lyma_extract"
ENV_BACKUP="/tmp/lyma_env_backup"

echo "Downloading v$VERSION to current directory..."
curl -fsSL -u "$NEXUS_USER:$NEXUS_TOKEN" "$NEXUS_URL" -o "$TEMP_ZIP"

echo "Extracting..."

# Backup .env if it exists
if [ -f "$TARGET_DIR/.env" ]; then
    echo "Preserving existing .env file..."
    cp "$TARGET_DIR/.env" "$ENV_BACKUP"
fi

rm -rf "$TARGET_DIR"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
unzip -q "$TEMP_ZIP" -d "$TEMP_DIR"

# Move the entire extracted folder (including hidden files) to the target directory
mv "$TEMP_DIR/lyma-docker-$VERSION" "$TARGET_DIR"

# Restore .env if it was backed up
if [ -f "$ENV_BACKUP" ]; then
    mv "$ENV_BACKUP" "$TARGET_DIR/.env"
fi

rm -rf "$TEMP_DIR" "$TEMP_ZIP"

echo "Successfully extracted to $(pwd)/$TARGET_DIR"
