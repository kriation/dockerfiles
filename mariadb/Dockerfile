# MariaDB image provided by SeeTheProgress
FROM seetheprogress/base:v0.1

MAINTAINER Michael Grosser <docker@seetheprogress.net>

# ENVs can be provided via ENV files inside the config and secrets dir.
# Following mandatory ENVs will be used:
# MYSQL_ROOT_PASSWORD
# Following optional ENVs will be used, if provided:
# MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD

# Use ENVs for easier editing
ENV GPG_KEY 0xcbcb082a1bb943db
ENV MARIADB_VERSION 10.1
ENV MARIADB_MIRROR http://ftp.osuosl.org/pub
ENV UBUNTU_VERSION trusty

# Add signing key for package verification
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $GPG_KEY

# Add source deb from specified mirror
RUN echo "deb $MARIADB_MIRROR/mariadb/repo/$MARIADB_VERSION/ubuntu $UBUNTU_VERSION main" > /etc/apt/sources.list.d/mariadb.list

# Install mariadb server from packages
RUN apt-get update \
    && apt-get install -y \
         mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Cleanup mysql data directory
RUN rm -rf /var/lib/mysql

# Use container directories
RUN mkdir -p /con/data \
    && mkdir -p /con/configuration \
    && mkdir -p /con/secret \

# Make default directories clear
RUN touch /con/data/DEFAULT \
    && touch /con/configuration/DEFAULT \
    && touch /con/secret/DEFAULT

# Enable overwriting settings via conf.d in config directory
# TODO: replace /etc/mysql/conf.d with /con/configuration/conf.d

# Add entrypoint script to enforce ENV settings and suggestions
COPY entrypoint.sh /entrypoint.sh
COPY default_check.sh /default_check.sh
RUN chmod +x /entrypoint.sh /default_check.sh

WORKDIR /usr/local/mysql
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306

# Use shell not exec for substitution to be available
CMD ["mysqld", "--datadir=/con/data", "--user=mysql"]
