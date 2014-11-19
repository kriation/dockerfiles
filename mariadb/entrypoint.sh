#/bin/bash
set -e

./default_check.sh

# Establish ENVs
./$CUSTOM_CONFIG_DIR/ENV
./$CUSTOM_SECRET_DIR/ENV

if [ -z "$(ls -A $CUSTOM_DATA_DIR)" -a "${1%_safe}" = 'mysqld' ]; then
    echo >&2 "ERROR: database is uninitialized."
    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo >&2 "No MYSQL_ROOT_PASSWORD was provided."
        echo >&2 "Add one via a volume and $CUSTOM_CONFIG_DIR/ENV."
        echo >&2 "Or via -e MYSQL_ROOT_PASSWORD (not recommended)."
        exit 1
    fi

    mysql_install_db --data=$CUSTOM_DATA_DIR

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
chown -R mysql:mysql $CUSTOM_DATA_DIR
chmod -R 0744 $CUSTOM_DATA_DIR

# TODO: Any permission changes needed for config dir?
chown -R mysql:mysql $CUSTOM_CONFIG_DIR
exec "$@"
