#!/bin/bash

# Add custom configuration file for PGQD if it doesn't already exist
if [ ! -f /usr/local/share/pgqd/pgqd.ini ]; then
  PGQ_USER="${POSTGRES_USER:-postgres}"
  cat <<EOF >> /usr/local/share/pgqd/pgqd.ini
[pgqd]
base_connstr = host=localhost port=5432 user=$PGQ_USER
pidfile = /var/run/pgqd/pgqd.pid
EOF
fi

# Start PGQD if the command is the default CMD
if [ "$1" = "postgres" ] && [ -z "${2+x}" ]; then
  pgqd -d /usr/local/share/pgqd/pgqd.ini &
fi

exec /usr/local/bin/docker-entrypoint.sh "$@"
