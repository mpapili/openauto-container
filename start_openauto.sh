#! /bin/bash

xhost +local:root
sudo setenforce 0 # NOTE - make sure you know what you're doing!

### removed options
# --privileged \
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    -v /etc/machine-id:/etc/machine-id:ro \
    -v /dev/dri:/dev/dri \
    --device /dev/snd \
    openauto-build
