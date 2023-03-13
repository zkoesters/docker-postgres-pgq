#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

PGQ_VERSION="${PGQ_VERSION%%-*}"

# Load PGQ into both template_database and $POSTGRES_DB
for DB in template_pgq "$POSTGRES_DB" "${@}"; do
    echo "Updating PGQ extensions '$DB' to $PGQ_VERSION"
    psql --dbname="$DB" -c "
        -- Upgrade PGQ
        CREATE EXTENSION IF NOT EXISTS pgq VERSION '$PGQ_VERSION';
        ALTER EXTENSION pgq UPDATE TO '$PGQ_VERSION';
    "
done
