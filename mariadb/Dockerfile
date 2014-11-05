# MariaDB image provided by SeeTheProgress
FROM seetheprogress/base:v0.1

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# Use ENVs for easier editing
ENV KEY 0xcbcb082a1bb943db
ENV MARIADB_VERSION 10.1
ENV MARIADB_MIRROR http://ftp.osuosl.org/pub
ENV UBUNTU_VERSION trusty

# Add signing key for package verification
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $KEY

# Add source deb from specified mirror
RUN echo "deb $MARIADB_MIRROR/mariadb/repo/$MARIADB_VERSION/ubuntu $UBUNTU_VERSION main" > /etc/apt/sources.list.d/mariadb.list

# Install mariadb server from packages
RUN apt-get update \
    && apt-get install -y \
         mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Add entrypoint script to enforce ENV settings and suggestions
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Cleanup mysql data directory
RUN rm -rf /var/lib/mysql

# Use custom directories
RUN mkdir -p /custom/data/mysql \
    && mkdir -p /custom/configuration \
    && mkdir -p /custom/secrets

VOLUME /custom/data /custom/configuration /custom/secrets

EXPOSE 3306
CMD ["mysqld", "--datadir=/custom/data/mysql", "--user=mysql"]
