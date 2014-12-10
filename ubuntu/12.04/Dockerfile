# Ubuntu image provided by SeeTheProgress
FROM ubuntu:12.04

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# Use container directories
RUN mkdir -p /con/proc \
    && mkdir -p /con/data \
    && mkdir -p /con/log \
    && mkdir -p /con/configuration \
    && mkdir -p /con/var \
    && mkdir -p /con/context \
    && mkdir -p /con/secret

# Make default directories clear
RUN touch /con/proc/DEFAULT \
    && touch /con/data/DEFAULT \
    && touch /con/log/DEFAULT \
    && touch /con/configuration/DEFAULT \
    && touch /con/var/DEFAULT \
    && touch /con/context/DEFAULT \
    && touch /con/secret/DEFAULT \
    && touch /con/configuration/ENV \
    && touch /con/secret/ENV \
    && echo "DEFAULT" > /con/seed

COPY default_check.sh /con/context/default_check.sh
RUN chmod +x /con/context/default_check.sh

# Prevent interactive installs
ENV DEBIAN_FRONTEND noninteractive

# Work around initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Update, upgrade and cleanup
RUN apt-get update -y \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
