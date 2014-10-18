# OpenLDAP image provided by SeeTheProgress
FROM seetheprogress/base:v0.1
MAINTAINER Michael Grosser <docker@seetheprogress.net>

# Prevent interactive installs
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

# Install necessary packages
RUN apt-get update && apt-get install -y slapd ldap-utils

# Prevent running slapd on install
RUN echo "#!/bin/sh\nexit 101" >/usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

# Expose ldap port
expose 389
