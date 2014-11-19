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
ENV CUSTOM_DATA_DIR /con/data
ENV CUSTOM_CONFIG_DIR /con/configuration
ENV CUSTOM_SECRET_DIR /con/secret

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

# Use custom directories
RUN mkdir -p $CUSTOM_DATA_DIR \
    && mkdir -p $CUSTOM_CONFIG_DIR \
    && mkdir -p $CUSTOM_SECRET_DIR \

# Make default directories clear
RUN touch $CUSTOM_DATA_DIR/DEFAULT \
    && touch $CUSTOM_CONFIG_DIR/DEFAULT \
    && touch $CUSTOM_SECRET_DIR/DEFAULT

# Enable overwriting settings via conf.d in config directory
# TODO: replace /etc/mysql/conf.d with $CUSTOM_CONFIG_DIR/conf.d

# Add entrypoint script to enforce ENV settings and suggestions
COPY entrypoint.sh /entrypoint.sh
COPY default_check.sh /default_check.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306

# Use shell not exec for substitution to be available
CMD mysqld --datadir=$CUSTOM_DATA_DIR --user=mysql
