#!/bin/bash

# Configuration variables
ESP32_CAM_URL="http://192.168.1.229:81"
OUTPUT_DIRECTORY="./data/dash"
VIDEO_BITRATE="200000" # Bitrate in bits per second
FRAME_RATE=10

# Ensure output directory exists
mkdir -p $OUTPUT_DIRECTORY

export GST_DEBUG=3

# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://192.168.1.211:81 -c:v libx264 -f mpegts - | \
# gst-launch-1.0 fdsrc ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! autovideosink

# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://192.168.1.95:81/stream -c:v libx264 -f mpegts - | \
# gst-launch-1.0 fdsrc ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! autovideosink


# gst-launch-1.0 souphttpsrc location=http://192.168.1.229:81/ do-timestamp=true is-live=true ! multipartdemux ! jpegparse ! jpegdec ! videoconvert ! autovideosink sync=false

# gst-launch-1.0 urisourcebin uri=http://192.168.1.229:81/ ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! autovideosink sync=false

GST_DEBUG=3 gst-launch-1.0 souphttpsrc location=http://192.168.1.229:81/ do-timestamp=true is-live=true ! multipartdemux ! jpegparse ! jpegdec ! videoconvert ! videorate ! 'video/x-raw,framerate=20/1' ! x264enc ! avimux ! filesink location=video.avi

GST_DEBUG=3 gst-launch-1.0 souphttpsrc location=http://192.168.1.229:81/ do-timestamp=true is-live=true ! multipartdemux ! jpegparse ! jpegdec ! videoconvert ! videorate ! 'video/x-raw,framerate=20/1' ! nvh264enc ! avimux ! filesink location=video.avi
#### working
# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://192.168.1.229:81/ -c:v libx264 -fflags nobuffer -tune zerolatency -g 25 -f mpegts - |
# gst-launch-1.0 fdsrc do-timestamp=true ! tsdemux ! h264parse ! avdec_h264 ! queue leaky=downstream max-size-buffers=1 max-size-bytes=0 max-size-time=0 ! videoconvert ! autovideosink sync=false




# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://http://192.168.0.22/stream -c:v libx264 -fflags nobuffer -tune zerolatency -g 25 -f mpegts - |
# gst-launch-1.0 fdsrc do-timestamp=true ! tsdemux ! h264parse ! avdec_h264 ! queue leaky=downstream max-size-buffers=1 max-size-bytes=0 max-size-time=0 ! videoconvert ! autovideosink sync=false



# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://192.168.1.211:81 -f rawvideo -pix_fmt yuv420p -c:v rawvideo - | \
# gst-launch-1.0 fdsrc ! video/x-raw,format=I420,width=800,height=600,framerate=25/1 ! videoconvert ! autovideosink

# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://192.168.1.211:81 -f rawvideo -pix_fmt yuv420p - | \
# gst-launch-1.0 fdsrc ! video/x-raw,format=I420,width=800,height=600 ! videoconvert ! autovideosink

# GStreamer command
# (echo "123456789000000000000987654321"; curl -s http://192.168.1.211:81;) | gst-launch-1.0 fdsrc do-timestamp=true ! \
#     multipartdemux ! jpegdec ! videoconvert ! videoscale ! videorate ! video/x-raw,framerate=$FRAME_RATE/1 ! x264enc bitrate=$(($VIDEO_BITRATE / 1000)) speed-preset=ultrafast tune=zerolatency ! h264parse ! autovideosink

# gst-launch-1.0 souphttpsrc location=$ESP32_CAM_URL is-live=true ! multipartdemux ! jpegdec ! videoconvert ! videoscale ! videorate ! video/x-raw,framerate=$FRAME_RATE/1 ! x264enc bitrate=$(($VIDEO_BITRATE / 1000)) speed-preset=ultrafast tune=zerolatency ! h264parse ! mpegtsmux ! splitmuxsink location=$OUTPUT_DIRECTORY/segment%05d.ts max-size-time=4000000000 muxer-factory=mp4mux

# (echo "--123456789000000000000987654321"; curl -s http://192.168.1.211:81;) | gst-launch-1.0 fdsrc do-timestamp=true ! \
#     multipartdemux boundary=--123456789000000000000987654321 ! jpegdec ! autovideosink
# ffmpeg -use_wallclock_as_timestamps 1 -re -i http://192.168.1.211:81 -f rawvideo -pix_fmt yuv420p - | \
# gst-launch-1.0 fdsrc ! video/x-raw,width=800,height=600,framerate=10/1 ! videoconvert ! autovideosink


# ffmpeg -r 10 -i http://192.168.1.211:81 -f rawvideo -pix_fmt yuv420p - | gst-launch-1.0 fdsrc