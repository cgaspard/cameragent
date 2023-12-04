#!/bin/bash

# Configuration variables
ESP32_CAM_URL="http://192.168.1.211:81"

# ffplay -vf "showinfo" $ESP32_CAM_URL
ffplay -vf "framestep=30" $ESP32_CAM_URL
# ffplay $ESP32_CAM_URL
