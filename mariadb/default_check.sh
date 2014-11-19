delimiter=">>>"

if [ -a "$CUSTOM_CONFIG_DIR/DEFAULT" ]; then
    echo >&2 "Default configuration directory in use."
    echo >&2 "Configurations can be provided via volume at $CUSTOM_CONFIG_DIR."
    echo >&2 "mysqld configuration will be read from $CUSTOM_CONFIG_DIR/conf.d/*."
    echo >&2 "ENVs will be read from $CUSTOM_CONFIG_DIR/ENV."
    echo >&2 "$delimiter"
fi

if [ -a "$CUSTOM_SECRETS_DIR/DEFAULT" ]; then
    echo >&2 "Default secret directory in use."
    echo >&2 "Keys/secrets can be provided via volume at $CUSTOM_SECRET_DIR."
    echo >&2 "Secure ENVs will be read from $CUSTOM_SECRET_DIR/ENV."
    echo >&2 "$delimiter"
fi

if [ -a "$CUSTOM_DATA_DIR/DEFAULT" ]; then
    echo >&2 "WARNING: Non persistent data directory in use! Data loss on restart!"
    echo >&2 "Please substitute $CUSTOM_DATA_DIR with a volume."
    echo >&2 "Use a Data Volume Container or another method to mount a volume."
    echo >&2 "$delimiter"
fi

