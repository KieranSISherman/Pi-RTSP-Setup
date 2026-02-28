#!/bin/bash

EXEC_DIR="$HOME/Pi-RTSP"
FFMPEG_CMD="ffmpeg -f v4l2 -input_format mjpeg -video_size 1280x720 -framerate 30 -i /dev/video0 -vcodec libx264 -preset ultrafast -tune zerolatency -f rtsp -rtsp_transport tcp rtsp://localhost:8554/stream"

echo "Starting RTSP Server"
"$EXEC_DIR/mediamtx" "$EXEC_DIR/mediamtx-rtsp.yml" &
RTSP_PID+$!
echo "RTSP_PID: $RTSP_PID"

sleep 2

echo "Starting FFmpeg Stream"
$FFMPEG_CMD &
FFMPEG_PID=$!
echo "FFmpeg PID: $FFMPEG_PID"

trap 'echo "Stopping..."; kill $FFMPEG_PID $RTSP_PID 2>/dev/null; exit' INT TERM

wait $FFMPEG_PID $RTSP_PID
