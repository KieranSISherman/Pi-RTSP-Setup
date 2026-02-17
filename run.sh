#!/bin/bash

#vars
REPO_URL="https://github.com/bluenviron/mediamtx/releases/download/v1.16.1/mediamtx_v1.16.1_linux_arm64.tar.gz"
EXTRACT_DIR="/tmp/rtspServer"
TAR_FILE="tmp/rtspServer-release.tar.gz"
EXEC_FILE="$EXTRACT_DIR/executable"
FFMPEG_CMD="ffmpeg -f v4l2 -video_size 1280x720 -framerate 30 -i /dev/video0 -vcodec libx264 -preset ultrafast -tune zerolatency -f rtsp -rtsp_transport tcp rtsp://localhost:8554/stream"

echo "Cloning repo"
curl -L -o "$TAR_FILE" "$REPO_URL"
if [ $? -ne 0 ]; then
    echo "Failed to download the release tarball"
    exit 1
fi

echo "Extracting tarball"
mkdir -p "$EXTRACT_DIR"
tar -xzf "$TAR_FILE" -C "$EXTRACT_DIR" --strip-components=1
if [ $? -ne 0 ]; then
    echo "Failed to extract tarball"
    exit 1
fi

echo "Changing perms"
chmod +x "$EXEC_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to change perms for the executable"
    exit 1
fi


echo "Launching repo process"
"$EXEC_FILE" &
REPO_PID=$!
echo "Repository process PID: $REPO_PID"

echo "Starting FFmpeg"
$FFMPEG_CMD &
FFMPEG_PID=$1
echo "FFmpeg process PID: $FFMPEG_PID"

wait $REPO_PID
wait $FFMPEG_PID
