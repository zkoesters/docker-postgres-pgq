#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "make update"! PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM postgres:15-alpine3.20

LABEL maintainer="Zachary Koesters <zachary@koeste.rs>"

ENV PGQ_VERSION=3.5.1
ENV PGQD_VERSION=3.5
ENV PGQ_SHA256=c5ab6f17138979e409aba412ecc3064ace8bbe334ee5d3fc00556ceecb820755
ENV PGQD_SHA256=a666e5e735f093ef09823ef0df1ba562b52e8fc9081ba1c8b3c3d662658f4916

ADD --checksum=sha256:"$PGQ_SHA256" https://github.com/pgq/pgq/releases/download/v"$PGQ_VERSION"/pgq-"$PGQ_VERSION".tar.gz pgq.tar.gz
ADD --checksum=sha256:"$PGQD_SHA256" https://github.com/pgq/pgqd/releases/download/v"$PGQD_VERSION"/pgqd-"$PGQD_VERSION".tar.gz pgqd.tar.gz

RUN set -eux \
    \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        tar \
    \
# get PGQ
    \
    && mkdir -p /usr/src/pgq \
    && tar \
        --extract \
        --file pgq.tar.gz \
        --directory /usr/src/pgq \
        --strip-components 1 \
    && rm pgq.tar.gz \
    \
# get PGQD
    \
    && mkdir -p /usr/src/pgqd \
    && tar \
        --extract \
        --file pgqd.tar.gz \
        --directory /usr/src/pgqd \
        --strip-components 1 \
    && rm pgqd.tar.gz \
    \
    && apk add --no-cache --virtual .build-deps \
        \
        clang15-dev \
        g++ \
        gcc \
        libevent-dev \
        llvm15-dev \
        make \
        py3-docutils \
        python3-dev \
    \
# build PGQ
    \
    && cd /usr/src/pgq \
    && make -j$(nproc) \
    && make install \
    \
# build PGQD
    \
    && cd /usr/src/pgqd \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    \
# add .pgq-rundeps
    && apk add --no-cache --virtual .pgq-rundeps \
        \
        ca-certificates \
        libevent \
        libstdc++ \
        python3 \
# clean
    && cd / \
    && rm -rf /usr/src/pgq \
    && rm -rf /usr/src/pgqd \
    && apk del .fetch-deps .build-deps \
# create directories
    && mkdir -p /var/run/pgqd \
    && chown postgres:postgres /var/run/pgqd \
    && mkdir -p /usr/local/share/pgqd \
    && chown postgres:postgres /usr/local/share/pgqd

COPY --from=tianon/gosu:1.17-alpine3.20 /gosu /usr/local/bin/
COPY ./initdb-pgq.sh /docker-entrypoint-initdb.d/10_pgq.sh
COPY ./update-pgq.sh /usr/local/bin
COPY docker-entrypoint-pgq.sh /usr/local/bin/

USER postgres
ENTRYPOINT ["docker-entrypoint-pgq.sh"]
CMD ["postgres"]
