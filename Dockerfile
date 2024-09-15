FROM archlinux

RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm \
    usbutils \
    android-tools \
    git \
    cmake \
    base-devel \
    protobuf \
    boost \
    libusb \
    openssl \
    qt5-multimedia \
    qt5-connectivity \
    pulseaudio \
    rtaudio \
    qt5-declarative \
    ttf-dejavu \
    ttf-liberation \
    fontconfig \
    mesa-libgl \
    libglvnd \
    xorg-server-xvfb \
    alsa-utils \
    alsa-plugins

# Set up workspace
RUN mkdir /app
WORKDIR /app

# Clone working forks of aasdk and openauto
RUN git clone https://github.com/Demon000/aasdk.git
RUN git clone https://github.com/Demon000/openauto.git

# Build aasdk with static linking
WORKDIR /app/aasdk
RUN mkdir build
WORKDIR /app/aasdk/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static" ..
RUN make -j$(nproc)
RUN make install

# Build openauto with static linking
WORKDIR /app/openauto
RUN sed -i 's/RtError/std::exception/g' openauto/Projection/RtAudioOutput.cpp
RUN mkdir build
WORKDIR /app/openauto/build
RUN cmake \
    -DAASDK_INCLUDE_DIRS="../aasdk/include" \
    -DAASDK_LIBRARIES="../aasdk/lib/libaasdk.a" \
    -DAASDK_PROTO_INCLUDE_DIRS="../aasdk" \
    -DAASDK_PROTO_LIBRARIES="../aasdk/lib/libaasdk_proto.a" \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_EXE_LINKER_FLAGS="-static" ..
RUN make -j$(nproc)
RUN make install

# Fix font issues
RUN fc-cache -f -v

CMD ["/usr/local/bin/autoapp"]

