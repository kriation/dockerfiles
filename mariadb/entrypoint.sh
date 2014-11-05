#!/bin/bash
set -e

# if /custom/data/mysql not initilized raise error
# if /custom/configuration has DEFAULT raise awareness, that something has to be mounted
# if /custom/secrets has DEFAULT raise awareness
# If /custom configuration has no MYSQL_ROOT_PASSWORD set raise error (how?)
# echo >&2 ''
# exit 1
# fi
# mysql_install_db --data=/custom/data/mysql
# chown -R mysql:mysql /custom/data/mysql
	

# These statements _must_ be on individual lines, and _must_ end with
# semicolons (no line breaks or comments are permitted).
# TODO proper SQL escaping on dat root password D:
#cat > /tmp/mysql-first-time.sql <<-EOSQL
#        UPDATE mysql.user SET host = "%", password = PASSWORD("${MYSQL_ROOT_PASSWORD}") WHERE user = "root" LIMIT 1 ;
#        DELETE FROM mysql.user WHERE user != "root" OR host != "%" ;
#        DROP DATABASE IF EXISTS test ;
#        FLUSH PRIVILEGES ;
#        EOSQL
#
#        set -- "$@" --init-file="$TEMP_FILE"
#fi

chown -R mysql:mysql $CUSTOM_DATA_DIR
chown -R mysql:mysql $CUSTOM_CONFIG_DIR
exec "$@"
