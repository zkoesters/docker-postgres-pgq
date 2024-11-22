#!/bin/bash
set -e

image="$1"

export POSTGRES_USER='my cool postgres user'
export POSTGRES_PASSWORD='my cool postgres password'
export POSTGRES_DB='my cool postgres database'

cname="pgq-container-$RANDOM-$RANDOM"
cid="$(docker run -d -e POSTGRES_USER -e POSTGRES_PASSWORD -e POSTGRES_DB --name "$cname" "$image")"
trap "docker rm -vf $cid > /dev/null" EXIT

psql() {
	docker run --rm -i \
		--link "$cname":pgq \
		--entrypoint psql \
		-e PGPASSWORD="$POSTGRES_PASSWORD" \
		"$image" \
		--host pgq \
		--username "$POSTGRES_USER" \
		--dbname "$POSTGRES_DB" \
		--quiet --no-align --tuples-only \
		"$@"
}

tries=10
while ! echo 'SELECT 1' | psql &> /dev/null; do
	(( tries-- ))
	if [ $tries -le 0 ]; then
		echo >&2 'postgres failed to accept connections in a reasonable amount of time!'
		echo 'SELECT 1' | psql # to hopefully get a useful error message
		false
	fi
	sleep 2
done

#[ "$(echo 'SELECT version FROM pg_catalog.pg_available_extension_versions WHERE name = '\'pgq\'' AND installed = true' | psql)" = 3.5 ]
[ "$(echo 'SELECT pgq.create_queue('\'test_queue\'')' | psql)" = 1 ]
[ "$(echo 'SELECT pgq.insert_event('\'test_queue\'', '\'test_event\'', '\'test_message\'')' | psql)" = 1 ]
[ "$(echo 'SELECT pgq.register_consumer('\'test_queue\'', '\'test_consumer\'')' | psql)" = 1 ]
