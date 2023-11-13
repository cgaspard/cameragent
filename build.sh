#!/bin/bash

# Log into Docker Hub
echo "Logging into Docker Hub..."
docker login

# Create a new builder which gives access to the new multi-platform features
docker buildx create --name mybuilder --use

# Start up the builder
docker buildx inspect --bootstrap

# Build and push the FFmpeg Docker image for both arm64 and amd64
echo "Building and pushing FFmpeg Docker image for arm64 and amd64..."
docker buildx build --platform linux/amd64,linux/arm64 -t cjgaspard/esp32-hls-ffmpeg -f ffmpeg.Dockerfile --push .

# Check for successful build and push
if [ $? -ne 0 ]; then
    echo "Failed to build and push FFmpeg Docker image."
    exit 1
fi

# Build and push the GStreamer Docker image for both arm64 and amd64
echo "Building and pushing GStreamer Docker image for arm64 and amd64..."
docker buildx build --platform linux/amd64,linux/arm64 -t cjgaspard/esp32-hls-gstreamer -f gstreamer.Dockerfile --push .

# Check for successful build and push
if [ $? -ne 0 ]; then
    echo "Failed to build and push GStreamer Docker image."
    exit 1
fi

echo "Both Docker images built and pushed successfully for arm64 and amd64."
