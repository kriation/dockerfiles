#!/bin/bash

delimiter=">>>"

if [ -a "/con/configuration/DEFAULT" ]; then
    echo >&2 "Default configuration directory in use."
    echo >&2 "Configurations can be provided via volume at /con/configuration."
    echo >&2 "App configuration will be read from /con/configuration/*."
    echo >&2 "ENVs will be read from /con/configuration/ENV."
    echo >&2 "$delimiter"
fi

if [ -a "/con/secret/DEFAULT" ]; then
    echo >&2 "Default secret directory in use."
    echo >&2 "Keys/secrets can be provided via volume at /con/secret."
    echo >&2 "Secure ENVs will be read from /con/secret/ENV."
    echo >&2 "$delimiter"
fi

if [ -a "/con/data/DEFAULT" ]; then
    echo >&2 "WARNING: Non persistent data directory in use! Data loss on restart!"
    echo >&2 "Please substitute /con/data with a volume."
    echo >&2 "Use a Data Volume Container or another method to mount a volume."
    echo >&2 "$delimiter"
fi

if [ -a "/con/log/DEFAULT" ]; then
    echo >&2 "Default log directory is in use."
    echo >&2 "Logs may not persist after a restart."
    echo >&2 "Please substitute /con/log with a volume."
    echo >&2 "$delimiter"
fi
