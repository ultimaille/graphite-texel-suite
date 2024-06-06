# FROM alpine:3.20
# RUN apk update && apk add git gcc make cmake clang gcc g++ libc-dev linux-headers libx11-dev glfw-dev libxrandr-dev libxcursor-dev libxi-dev libxext-dev

FROM debian:bookworm

RUN apt-get update && apt-get install git make cmake clang gcc g++ libc-dev libx11-dev libglfw3 libxrandr-dev libxcursor-dev libxi-dev  libxext-dev libxinerama-dev -y

# Clone graphite
RUN git clone https://github.com/BrunoLevy/GraphiteThree.git --recurse-submodules

# Clone graphite add-on loader
RUN git clone https://github.com/ultimaille/graphite-addon-loader.git

# Clone graphite add-example
RUN git clone https://github.com/ultimaille/graphite-addon-examples.git

# Build Graphite
RUN cd GraphiteThree && ./configure.sh && cd build/Linux64-gcc-dynamic-Release && make -j

# Build add-on examples
RUN cd graphite-addon-examples && cmake -B build && cd build && make -j

ENV HOME=/home
# RUN export HOME=/home
# Copy add-on loader to Graphite
# COPY graphite-addon-loader/addon_loader.lua /root/home/addon_loader.lua

# Add graphite config
ADD graphite.ini /home/graphite.ini
ADD addon_loader.txt GraphiteThree

# CMD GraphiteThree/build/Linux64-gcc-dynamic-Release/bin/graphite

