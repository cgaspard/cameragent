#!/bin/bash

# Default values for environment variables
ESP32_CAM_URL=${ESP32_CAM_URL:-"http://your_default_esp32_cam_address"}
AUDIO_FEED_URL=${AUDIO_FEED_URL:-""} # URL for the separate audio feed
OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY:-"/var/www/html/hls"}
VIDEO_BITRATE=${VIDEO_BITRATE:-"800k"}
FRAME_RATE=${FRAME_RATE:-30}         # e.g., 30, 24, etc.
RESOLUTION=${RESOLUTION:-1280x720}   # e.g., 1280x720 (720p), 1920x1080 (1080p), etc.
AUDIO_BITRATE=${AUDIO_BITRATE:-"96k"}
HLS_TIME=${HLS_TIME:-4}
RECONNECT_STREAM=${RECONNECT_STREAM:-true}

# FFmpeg reconnection options
RECONNECT_OPTIONS=""
if [ "$RECONNECT_STREAM" = "true" ]; then
    RECONNECT_OPTIONS="-reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 2"
fi

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIRECTORY

# FFmpeg command
FFMPEG_CMD="ffmpeg -i $ESP32_CAM_URL $RECONNECT_OPTIONS"

# If an audio feed URL is provided, add it to the FFmpeg command
if [ -n "$AUDIO_FEED_URL" ]; then
    FFMPEG_CMD="$FFMPEG_CMD -i $AUDIO_FEED_URL"
fi

# Continue building the FFmpeg command
FFMPEG_CMD="$FFMPEG_CMD -c:v libx264 -c:a aac -b:v $VIDEO_BITRATE -b:a $AUDIO_BITRATE  -r $FRAME_RATE -s $RESOLUTION -f hls -hls_time $HLS_TIME -hls_playlist_type event $OUTPUT_DIRECTORY/stream.m3u8"

# Run the command
eval $FFMPEG_CMD &

# Run the FFmpeg command in the background
echo "Starting FFmpeg..."
eval $FFMPEG_CMD &

# Start Nginx in the foreground
echo "Starting Nginx..."
nginx -g 'daemon off;'