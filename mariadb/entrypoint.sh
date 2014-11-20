#!/bin/bash
set -e

./con/context/default_check.sh

# Source ENVs
if [ -a "/con/configuration/ENV" ]; then
    source /con/configuration/ENV
fi

if [ -a "/con/secret/ENV" ]; then
    source /con/secret/ENV
fi

if [ ! -d "/con/data/mysql" -a "${1%_safe}" = 'mysqld' ]; then
    echo >&2 "ERROR: database is uninitialized."
    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo >&2 "No MYSQL_ROOT_PASSWORD was provided."
        echo >&2 "Add one via a volume at /con/configuration"
        echo >&2 "with /con/configuration/ENV and you password."
        echo >&2 "Or via -e MYSQL_ROOT_PASSWORD (not recommended)."
        exit 1
    fi

    mysql_install_db --data=/con/data

    # These statements _must_ be on individual lines, and _must_ end with
    # semicolons (no line breaks or comments are permitted).
    # TODO proper SQL escaping on ALL the things D:
    TEMP_FILE='/tmp/mysql-first-time.sql'
    cat > "$TEMP_FILE" <<-EOSQL
        DELETE FROM mysql.user ;
        CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
        GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
        DROP DATABASE IF EXISTS test ;
EOSQL

    if [ "$MYSQL_DATABASE" ]; then
        echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE ;" >> "$TEMP_FILE"
    fi

    if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
        echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$TEMP_FILE"
	
        if [ "$MYSQL_DATABASE" ]; then
            echo "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' ;" >> "$TEMP_FILE"
        fi
    fi
	
    echo 'FLUSH PRIVILEGES ;' >> "$TEMP_FILE"
	
    set -- "$@" --init-file="$TEMP_FILE"
fi

# Adjust owner and permissions
chown -R mysql:mysql /con/data /con/log
chmod -R 0744 /con/data /con/log

exec "$@"
