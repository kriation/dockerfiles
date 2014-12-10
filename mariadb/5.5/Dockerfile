# MariaDB image provided by SeeTheProgress
#FROM ubuntu:14.04
# Use updated ubuntu image
FROM seetheprogress/ubuntu:14.04

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# ENVs can be provided via ENV files inside the config and secrets dir.
# Following mandatory ENVs will be used:
# MYSQL_ROOT_PASSWORD
# Following optional ENVs will be used, if provided:
# MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD

# Use ENVs for easier editing
ENV GPG_KEY 0xcbcb082a1bb943db
ENV MARIADB_VERSION 5.5
ENV MARIADB_MIRROR http://ftp.osuosl.org/pub
ENV UBUNTU_VERSION trusty

# Add signing key for package verification
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $GPG_KEY

# Add source deb from specified mirror
RUN echo "deb $MARIADB_MIRROR/mariadb/repo/$MARIADB_VERSION/ubuntu $UBUNTU_VERSION main" > /etc/apt/sources.list.d/mariadb.list

# Install mariadb server from packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Cleanup mysql data directory
RUN rm -rf /var/lib/mysql

# Set default permissions
RUN chmod -R 744 /con
RUN chown -R mysql:mysql /con

# Add entrypoint script to enforce ENV settings and suggestions
COPY entrypoint.sh /con/context/entrypoint.sh
RUN chmod +x /con/context/entrypoint.sh

ENTRYPOINT ["/con/context/entrypoint.sh"]

EXPOSE 3306

# Use shell not exec for substitution to be available
CMD ["mysqld", \
    "--datadir=/con/data", \
    "--defaults-extra-file=/con/configuration/my.conf", \
    "--log-bin=/con/log/mariadb-bin", \
    "--log-bin-index=/con/log/mariadb-bin.index", \
    "--user=mysql"]
