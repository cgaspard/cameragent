# Use Ubuntu as the base image
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install FFmpeg, GStreamer, and Nginx
RUN apt-get update && \
    apt-get install -y ffmpeg nginx gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the HLS stream
RUN mkdir -p /var/www/html/hls

# Copy Nginx configuration
COPY gstreamer-nginx.conf /etc/nginx/nginx.conf

# Copy the entrypoint script for GStreamer
COPY gstreamer-entrypoint.sh /entrypoint.sh

# Copy the HTML file
COPY index.html /var/www/html/index.html

# Make the GStreamer entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose port 80 for HTTP
EXPOSE 80

# Set the entrypoint script for GStreamer
ENTRYPOINT ["/entrypoint.sh"]