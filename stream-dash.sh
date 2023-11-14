#!/bin/bash

# Configuration variables
ESP32_CAM_URL="http://192.168.1.211:81"
OUTPUT_DIRECTORY="./data/dash"
VIDEO_BITRATE="200k"
HLS_TIME=4
FRAME_RATE=10

# Ensure output directory exists
mkdir -p $OUTPUT_DIRECTORY

ffmpeg -i $ESP32_CAM_URL -c:v libx264 -b:v $VIDEO_BITRATE -s 1280x720 -c:a aac -b:a 128k -f dash -window_size 5 -extra_window_size 10 -hls_playlist 1 $OUTPUT_DIRECTORY/manifest.mpd
