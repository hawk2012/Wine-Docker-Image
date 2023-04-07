FROM nvcr.io/nvidia/cuda:11.8.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        ca-certificates \
        language-pack-en \
        language-pack-ru \
        locales \
        locales-all \
        dirmngr \
        gpg \
        gpg-agent \
        wget

# Install Wine
RUN dpkg --add-architecture i386 && \
mkdir -pm755 /etc/apt/keyrings && \
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
apt-get update -y && \
# Wine 8.0 stable has some issues
# Use Wine 8.0 staging instead
apt-get install -y --install-recommends winehq-staging winetricks

# GStreamer plugins
RUN apt-get update -y && \
    apt-get install -y --install-recommends \
        gstreamer1.0-libav:i386 \
        gstreamer1.0-plugins-bad:i386 \
        gstreamer1.0-plugins-base:i386 \
        gstreamer1.0-plugins-good:i386 \
        gstreamer1.0-plugins-ugly:i386 \
        gstreamer1.0-pulseaudio:i386

# Install dependencies for display scaling
RUN apt-get update -y && \
    apt-get install -y --install-recommends \
        build-essential \
        bc \
        git \
        xpra \
        xvfb \
        python3 \
        python3-pip

# Install OpenGL acceleration for display scaling
RUN pip3 install PyOpenGL PyOpenGL_accelerate

# Install display scaling script
RUN cd /tmp && \
    git clone https://github.com/kaueraal/run_scaled.git && \
    cp /tmp/run_scaled/run_scaled /usr/local/bin/

# Install missing fonts for Chinese
RUN apt-get update -y && \
    apt-get install -y --install-recommends \
        fonts-wqy-microhei

# Install driver for Intel HD graphics
RUN apt-get -y install libgl1-mesa-glx libgl1-mesa-dri

ENV LC_ALL ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
# Make sure the terminal is still English
ENV LANGUAGE en_US.UTF-8
