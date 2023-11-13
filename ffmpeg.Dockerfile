# Use Ubuntu as the base image
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install FFmpeg and Nginx
RUN apt-get update && \
    apt-get install -y ffmpeg nginx && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the HLS stream
RUN mkdir -p /var/www/html/hls

# Copy Nginx configuration
COPY ffmpeg-nginx.conf /etc/nginx/nginx.conf

# Copy the entrypoint script
COPY ffmpeg-entrypoint.sh /entrypoint.sh

# Copy the HTML file
COPY index.html /var/www/html/index.html

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose port 80 for HTTP
EXPOSE 80

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]