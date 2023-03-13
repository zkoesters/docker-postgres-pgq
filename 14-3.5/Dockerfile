#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "make update"! PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM postgres:14-bullseye

LABEL maintainer="Zachary Koesters <zachary@koesters.io>"

ENV PGQ_VERSION 3.5-1.pgdg110+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-pgq3-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           ca-certificates \
           \
           pgqd=$PGQ_VERSION \
           postgresql-$PG_MAJOR-pgq3=$PGQ_VERSION \
      && rm -rf /var/lib/apt/lists/* \
      && mkdir -p /var/run/pgqd \
      && chown postgres:postgres /var/run/pgqd \
      && mkdir -p /usr/local/share/pgqd \
      && chown postgres:postgres /usr/local/share/pgqd

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-pgq.sh /docker-entrypoint-initdb.d/10_pgq.sh
COPY ./update-pgq.sh /usr/local/bin
COPY docker-entrypoint-pgq.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint-pgq.sh"]
CMD ["postgres"]
