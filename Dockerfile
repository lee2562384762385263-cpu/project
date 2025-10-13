FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Qt6 and development tools
RUN apt-get update && apt-get install -y \
    qt6-base-dev \
    qt6-declarative-dev \
    cmake \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Create build directory and build
RUN mkdir -p build && cd build && \
    cmake .. && \
    cmake --build .

# Set the executable as the entry point
CMD ["./build/notificationapp"]