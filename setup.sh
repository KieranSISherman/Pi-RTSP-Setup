#!/bin/bash

TAR_FILE="/tmp/mediamtx-release.tar.gz"
EXTRACT_DIR="$HOME/Pi-RTSP"
REPO_URL="https://github.com/bluenviron/mediamtx/releases/download/v1.16.1/mediamtx_v1.16.1_linux_arm64.tar.gz"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_NAME="rtspStartup.service"

echo "Script Directory: $SCRIPT_DIR"
sudo apt update

if ! command -v curl &> /dev/null
then
    echo "Curl not found, installing..."
    sudo apt install -y curl
else
    echo "Curl already installed"
fi

if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg not found, installing..."
    sudo apt install -y ffmpeg
else
    echo "FFmpeg already installed"
fi

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
cp "$SCRIPT_DIR/mediamtx-rtsp.yml" "$EXTRACT_DIR/mediamtx-rtsp.yml"
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

read -p "Do you want to set runRtsp.sh to run on startup? (y/n): " startupAnswer
if [[ "$startupAnswer" == [Yy] ]]; then
    read -p "Enter username to run this service (default 'vex'): " TARGET_USER
    TARGET_USER=${TARGET_USER:-vex}

    if ! id "$TARGET_USER" &>/dev/null; then
        echo "User: '$TARGET_USER' does not exist. Exiting."
        exit 1
    fi

    echo "Using username: $TARGET_USER"

    sudo bash -c "cat > /etc/systemd/system/$SERVICE_NAME" <<EOF
[Unit]
Description=Auto-start mediamtx and ffmpeg rtsp for camera streaming
After=network.target

[Service]
ExecStart=$EXTRACT_DIR/runRtsp.sh
WorkingDirectory=$EXTRACT_DIR
User=$TARGET_USER
Group=$TARGET_USER
Restart=no

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    echo "Service $SERVICE_NAME created and enabled"
fi

read -p "Do you want to start the RTSP Server? (y/n): " runAnswer
if [[ "$runAnswer" == [Yy] ]]; then
    echo "Starting runRtsp.sh"
    bash "$EXTRACT_DIR/runRtsp.sh"
fi
