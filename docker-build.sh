#!/bin/bash

# Build Docker image
echo "Building Docker image..."
docker build -t qt-notification-app .

# Run the container
echo "Running the application in Docker..."
docker run --rm -it qt-notification-app