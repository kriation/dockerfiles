# FireFox image provided by SeeTheProgress
FROM seetheprogress/ubuntu:14.04

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# Use ENVs for easier versioning
ENV FIREFOX_VERSION 34.0.5
ENV FIREFOX_DOWNLOAD https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-i686/en-US/firefox-$FIREFOX_VERSION.tar.bz2

# Prepare directory
RUN mkdir /con/context/firefox
RUN rm -f /opt/firefox

# Install latest FireFox
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
    && wget $FIREFOX_DOWNLOAD -P /con/context/ \
    && apt-get purge wget \
    && tar jxf /con/context/firefox*.tar.bz2 -C /opt/firefox/ \
    && rm /con/context/firefox*.tar.bz2 \
    && ln -s /opt/firefox/firefox /usr/bin/firefox \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/con/context/entrypoint.sh"]

CMD firefox
