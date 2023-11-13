#!/bin/bash

# Default values for environment variables
ESP32_CAM_URL=${ESP32_CAM_URL:-"http://your_default_esp32_cam_address"}
AUDIO_FEED_URL=${AUDIO_FEED_URL:-""} # URL for the separate audio feed
VIDEO_BITRATE=${VIDEO_BITRATE:-800} # In kbps
AUDIO_BITRATE=${AUDIO_BITRATE:-96} # In kbps
HLS_TIME=${HLS_TIME:-4}
RECONNECT_STREAM=${RECONNECT_STREAM:-true}
FRAME_RATE=${FRAME_RATE:-30}         # e.g., 30, 24, etc.
RESOLUTION=${RESOLUTION:-1280x720}   # e.g., 1280x720 (720p), 1920x1080 (1080p), etc.

# Base GStreamer pipeline for video
GST_PIPELINE="souphttpsrc location=$ESP32_CAM_URL is-live=true"
if [ "$RECONNECT_STREAM" = "true" ]; then
    GST_PIPELINE="$GST_PIPELINE do-timestamp=true retry=5"
fi
GST_PIPELINE="$GST_PIPELINE ! multipartdemux ! jpegdec ! videoconvert"

# Add frame rate and resolution settings
GST_PIPELINE="$GST_PIPELINE ! videorate ! videoscale ! video/x-raw,framerate=$FRAME_RATE/1,width=$(echo $RESOLUTION | cut -d'x' -f1),height=$(echo $RESOLUTION | cut -d'x' -f2)"

# Continue with the video encoding settings
GST_PIPELINE="$GST_PIPELINE ! x264enc bitrate=$(($VIDEO_BITRATE / 1000)) speed-preset=ultrafast ! h264parse ! mpegtsmux name=mux"

# Add audio feed to the pipeline if provided
if [ -n "$AUDIO_FEED_URL" ]; then
    GST_PIPELINE="$GST_PIPELINE souphttpsrc location=$AUDIO_FEED_URL is-live=true"
    if [ "$RECONNECT_STREAM" = "true" ]; then
        GST_PIPELINE="$GST_PIPELINE do-timestamp=true retry=5"
    fi
    GST_PIPELINE="$GST_PIPELINE ! decodebin ! audioconvert ! audioresample ! avenc_aac bitrate=$(($AUDIO_BITRATE * 1000)) ! aacparse ! mux."
fi

# HLS sink configuration
GST_PIPELINE="$GST_PIPELINE hlssink2 location=/var/www/html/hls/segment%05d.ts playlist-location=/var/www/html/hls/stream.m3u8 playlist-length=$HLS_TIME max-files=$((($HLS_TIME * 5) + 1)) target-duration=$HLS_TIME"

# Run the GStreamer pipeline in the background
echo "Starting GStreamer..."
eval gst-launch-1.0 -e $GST_PIPELINE &

# Start Nginx in the foreground
echo "Starting Nginx..."
nginx -g 'daemon off;'
