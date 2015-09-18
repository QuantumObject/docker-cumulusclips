#!/bin/sh

apt-get update && apt-get install -y -q build-essential \
                              git-core \
                              checkinstall \
                              yasm \
                              texi2html \
                              libvorbis-dev \
                              libx11-dev \
                              libvpx-dev \
                              libxfixes-dev \
                              zlib1g-dev \
                              pkg-config \
                              libx264-dev \
                              libfaac-dev \
                              netcat 
                              
FFMPEG_VERSION=2.7.2

 cd /usr/local/src
 if [ ! -d "/usr/local/src/ffmpeg-${FFMPEG_VERSION}" ]; then
    wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
    tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
    rm "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
 fi

 cd "ffmpeg-${FFMPEG_VERSION}"
 ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx --enable-gpl --enable-libx264 --enable-nonfree --enable-libfaac
 make
 checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default

# chmod +x install-ffmpeg.sh
# ./install-ffmpeg.sh 
 
 ffmpeg -version
 
 rm -R "/usr/local/src/ffmpeg-${FFMPEG_VERSION}"
 apt-get clean 
 rm -rf /tmp/* /var/tmp/*
 rm -rf /var/lib/apt/lists/*
