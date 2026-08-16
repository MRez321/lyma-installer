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

echo "Downloading v$VERSION to current directory..."
curl -fsSL -u "$NEXUS_USER:$NEXUS_TOKEN" "$NEXUS_URL" -o "$TEMP_ZIP"

echo "Extracting..."
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
unzip -q "$TEMP_ZIP" -d "$TEMP_DIR"

# Move contents of the nested git archive folder directly into ./lyma-docker
mv "$TEMP_DIR/lyma-docker-$VERSION/"* "$TARGET_DIR/"

rm -rf "$TEMP_DIR" "$TEMP_ZIP"

echo "Successfully extracted to $(pwd)/$TARGET_DIR"
