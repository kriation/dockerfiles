# Ubuntu image provided by SeeTheProgress
FROM ubuntu:14.04

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# Prevent interactive installs
ENV DEBIAN_FRONTEND noninteractive

# Work around initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Update, upgrade and cleanup
RUN apt-get update -y \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
