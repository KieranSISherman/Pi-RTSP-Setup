#!/bin/bash

TAR_FILE="/tmp/mediamtx-release.tar.gz"
EXTRACT_DIR="$HOME/Pi-RTSP/"
REPO_URL="https://github.com/bluenviron/mediamtx/releases/download/v1.16.1/mediamtx_v1.16.1_linux_arm64.tar.gz"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Script Directory: $SCRIPT_DIR"

echo "Installing Curl"
sudo apt update
sudo apt install -y curl

echo "Cloning Repo"
curl -L -o "$TAR_FILE" "$REPO_URL"
if [ $? -ne 0 ]; then
    echo "Failed to download the release tarball"
    exit 1
fi

echo "Extracting Tarball"
mkdir -p "$EXTRACT_DIR"
tar -xzf "$TAR_FILE" -C "$EXTRACT_DIR"
cp "$SCRIPT_DIR/runRtsp.sh" "$EXTRACT_DIR/runRtsp.sh"
if [ $? -ne 0 ]; then
    echo "Failed to extract release tarball"
    exit 1
fi

echo "Changing Permissions of Executables"
chmod +x "$EXTRACT_DIR/mediamtx"
chmod +x "$EXTRACT_DIR/runRtsp.sh"
if [ $? -ne 0 ]; then
    echo "Failed to change permissions for executables"
    exit 1
fi

echo "Starting runRtsp.sh"
bash "$EXTRACT_DIR/runRtsp.sh"

read -p "Do you want to start the RTSP Server? (y/n): " answer
if [[ "$answer" == [Yy] ]]; then
    echo "Starting runRtsp.sh"
    bash "$EXTRACT_DIR/runRtsp.sh"
fi