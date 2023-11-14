#!/bin/bash

# Configuration variables
ESP32_CAM_URL="http://192.168.1.211:81"
OUTPUT_DIRECTORY="./data/hls"
VIDEO_BITRATE="200k"
HLS_TIME=4
FRAME_RATE=10

# Ensure output directory exists
mkdir -p $OUTPUT_DIRECTORY

# FFmpeg command to process the ESP32 stream
# ffmpeg -re -i $ESP32_CAM_URL -c:v libx264 -preset ultrafast -r $FRAME_RATE -b:v $VIDEO_BITRATE -f hls -hls_time $HLS_TIME -hls_playlist_type event $OUTPUT_DIRECTORY/stream.m3u8
# ffmpeg -re -i $ESP32_CAM_URL -c:v libvpx-vp9 -preset ultrafast -r $FRAME_RATE -b:v $VIDEO_BITRATE -f hls -hls_time $HLS_TIME -hls_playlist_type event $OUTPUT_DIRECTORY/stream.m3u8
# ffmpeg -re -i $ESP32_CAM_URL -c:v mjpeg  -preset ultrafast -r $FRAME_RATE -b:v $VIDEO_BITRATE -f hls -hls_time $HLS_TIME -hls_playlist_type event $OUTPUT_DIRECTORY/stream.m3u8
# ffmpeg -re -i $ESP32_CAM_URL -c:v mpeg2video  -preset ultrafast -r $FRAME_RATE -b:v $VIDEO_BITRATE -f hls -hls_time $HLS_TIME -hls_playlist_type event $OUTPUT_DIRECTORY/stream.m3u8

ffmpeg -i $ESP32_CAM_URL -c:v h264_videotoolbox -r $FRAME_RATE -b:v $VIDEO_BITRATE -f hls -hls_time $HLS_TIME -hls_playlist_type event $OUTPUT_DIRECTORY/stream.m3u8

# ffmpeg -i $ESP32_CAM_URL -c copy -map 0 -f segment -segment_time 900 -reset_timestamps 1 output_%03d.avi
