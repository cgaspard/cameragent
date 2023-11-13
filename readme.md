
# ESP32 HLS Stream Docker Containers

## Overview

This repository contains Docker containers for streaming video from an ESP32 camera module. The project includes two separate containers: one using FFmpeg and the other using GStreamer. These containers are designed to capture an MJPEG stream from an ESP32 camera, re-encode it to H.264, and serve it via an HLS (HTTP Live Streaming) stream that can be accessed in a web browser.

## Features

- **FFmpeg and GStreamer Support:** Two separate containers for each streaming method.
- **HLS Streaming:** Re-encodes MJPEG to H.264 and serves via HLS for broad compatibility.
- **Multi-Architecture Builds:** Containers built for both `amd64` and `arm64` architectures.
- **Configurable Stream Quality:** Environment variables to adjust bitrate, frame rate, and resolution.
- **Reconnection Logic:** Automated reconnection attempts for unstable camera streams.
- **Nginx for Web Serving:** Includes Nginx to serve the HLS stream and a web interface.

## Prerequisites

- Docker installed on your machine.
- An ESP32 camera module set up and accessible over the network.

## Usage

### Pulling the Docker Images

Pull the images from Docker Hub:

``` bash
docker pull cjgaspard/esp32-hls-ffmpeg
docker pull cjgaspard/esp32-hls-gstreamer
```

### Running the Containers

Run the FFmpeg container:

```bash
docker run -d \
    --name esp32-ffmpeg \
    -p 8080:80 \
    -e ESP32_CAM_URL="http://your_esp32_cam_address" \
    cjgaspard/esp32-hls-ffmpeg
```

Run the GStreamer container:

```bash
docker run -d \
    --name esp32-gstreamer \
    -p 8081:80 \
    -e ESP32_CAM_URL="http://your_esp32_cam_address" \
    cjgaspard/esp32-hls-gstreamer
```

## Configuration

You can customize the stream by setting the following environment variables:

- `ESP32_CAM_URL`: The URL of your ESP32 camera stream.
- `AUDIO_FEED_URL`: (Optional) The URL for a separate audio feed.
- `VIDEO_BITRATE`: The desired video bitrate (e.g., "800k").
- `AUDIO_BITRATE`: The desired audio bitrate (e.g., "96k").
- `FRAME_RATE`: The desired frame rate (e.g., "30").
- `RESOLUTION`: The desired video resolution (e.g., "1280x720").

## Accessing the Stream

After running the container, access the HLS stream through a web browser:

- For FFmpeg container: `http://localhost:8080/`
- For GStreamer container: `http://localhost:8081/`

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please submit pull requests or open issues for any enhancements, bug fixes, or improvements.
