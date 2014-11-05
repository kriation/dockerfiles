#!/bin/bash
set -e

delimiter=">>>"

if [ -a "$CUSTOM_CONFIG_DIR/DEFAULT" ]; then
    echo >&2 "Default configuration directory in use."
    echo >&2 "Configurations can be provided via volume at $CUSTOM_CONFIG_DIR."
    echo >&2 "mysqld configuration will be read from $CUSTOM_CONFIG_DIR/conf.d/*."
    echo >&2 "ENVs will be read from &CUSTOM_CONFIG_DIR/ENV."
    echo >&2 "$delimiter"
else
    $CUSTOM_CONFIG_DIR/ENV
fi

if [ -a "$CUSTOM_SECRETS_DIR/DEFAULT" ]; then
    echo >&2 "Default secret directory in use."
    echo >&2 "Keys/secrets can be provided via volume at $CUSTOM_SECRETS_DIR."
    echo >&2 "Secure ENVs will be read from $CUSTOM_SECRETS_DIR/ENV."
    echo >&2 "$delimiter"
else
    $CUSTOM_SECRETS_DIR/ENV
fi

if [ -a "$CUSTOM_DATA_DIR/DEFAULT" ]; then
    echo >&2 "WARNING: Non persistent data directory in use! Data loss on restart!"
    echo >&2 "Please substitute $CUSTOM_DATA_DIR with a volume."
    echo >&2 "Use a Data Volume Container or another method to mount a volume."
    echo >&2 "$delimiter"    
else

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
fi

# Adjust owner and permissions
chown -R mysql:mysql $CUSTOM_DATA_DIR
chmod -R 0744 $CUSTOM_DATA_DIR

# TODO: Any permission changes needed for config dir?
chown -R mysql:mysql $CUSTOM_CONFIG_DIR
exec "$@"
