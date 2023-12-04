#!/bin/bash

# Configuration variables
ESP32_CAM_URL="http://192.168.1.211:81"
OUTPUT_DIRECTORY="./data/save"
SEGMENT_TIME=10

# Ensure output directory exists
mkdir -p $OUTPUT_DIRECTORY

ffmpeg -i $ESP32_CAM_URL -c copy -map 0 -f segment -segment_time $SEGMENT_TIME -reset_timestamps 1 $OUTPUT_DIRECTORY/output_%03d.avi
