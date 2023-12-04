#!/bin/bash

# Configuration variables
# ESP32_CAM_URL="http://192.168.1.211:81"
ESP32_CAM_URL="http://192.168.1.229:81"
OUTPUT_DIRECTORY="./data/dash"
VIDEO_BITRATE="100k"
HLS_TIME=4
INCOMMING_FRAME_RATE=5
OUTPUT_FRAME_RATE=10

# Ensure output directory exists
mkdir -p $OUTPUT_DIRECTORY

ffmpeg -re -r $INCOMMING_FRAME_RATE -i $ESP32_CAM_URL -preset ultrafast -c:v libx264 -b:a $VIDEO_BITRATE -f dash -window_size 5 -extra_window_size 10 -hls_playlist 1 $OUTPUT_DIRECTORY/manifest.mpd

# ffmpeg -re -r 10 -i $ESP32_CAM_URL -preset ultrafast -vf "fps=$FRAME_RATE,setpts=PTS-STARTPTS" -c:v h264_videotoolbox -b:v $VIDEO_BITRATE -s 800x600 -c:a aac -b:a $VIDEO_BITRATE -f dash -window_size 5 -extra_window_size 10 -hls_playlist 1 $OUTPUT_DIRECTORY/manifest.mpd
# ffmpeg -i $ESP32_CAM_URL -r 8 -c:v libx264 -f dash -window_size 5 -extra_window_size 10 $OUTPUT_DIRECTORY/manifest.mpd
# ffmpeg -i $ESP32_CAM_URL -r 8 -c:v libx264 -f dash -window_size 5 -extra_window_size 10 -hls_playlist 1  -hls_playlist 1 $OUTPUT_DIRECTORY/manifest.mpd
# ffmpeg -i $ESP32_CAM_URL -c:v mjpeg -b:v 200k -s 800x600 -c:a aac -b:a 200k -f dash -window_size 5 -extra_window_size 10 -hls_playlist 1 ./manifest.mpd
# ffmpeg -i $ESP32_CAM_URL -c:v h264_videotoolbox -b:v $VIDEO_BITRATE -f dash $OUTPUT_DIRECTORY/manifest.mpd

# ffprobe -i $ESP32_CAM_URL
