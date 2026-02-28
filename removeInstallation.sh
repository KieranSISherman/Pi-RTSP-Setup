#!/bin/bash

SERVICE_FILE="/etc/systemd/system/rtspStartup.service"
RTSP_DIR="$( eval echo ~${SUDO_USER})/Pi-RTSP"

echo "Removing startup service file"
rm $SERVICE_FILE
if [ $? -ne 0 ]; then
    echo "Failed to remove service file at: $SERVICE_FILE"
    exit 1
fi

echo "Removing Pi-RTSP directory"
rm -rf "$RTSP_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to remove Pi-RTSP files and directory at: $RTSP_DIR"
    exit 1
fi

echo "Success"
