# OpenRa image provided by SeeTheProgress
FROM seetheprogress/ubuntu:14.04

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# ENVs for easier editing
ENV OPENRA_VERSION 20141029
ENV OPENRA_DEB openra_release.${OPENRA_VERSION}_all.deb
ENV OPENRA_DOWNLOAD https://github.com/OpenRA/OpenRA/releases/download/release-${OPENRA_VERSION}/${OPENRA_DEB}

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        mono-dmcs \
        libmono-system-windows-forms4.0-cil \
        cli-common-dev \
        libfreetype6 \
        libopenal1 \
        liblua5.1-0 \
        libsdl2-2.0-0 \
        xdg-utils \
        zenity \
        wget
RUN wget $OPENRA_DOWNLOAD -P /con/context \
    && dpkg -i /con/context/$OPENRA_DEB \
#    && rm /con/context/$OPENRA_DEB \
    && rm -rf /var/lib/apt/lists/*
