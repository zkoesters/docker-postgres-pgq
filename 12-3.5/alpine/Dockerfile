#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "make update"! PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM postgres:12-alpine3.17

LABEL maintainer="Zachary Koesters <zachary@koesters.io>"

ENV PGQ_VERSION 3.5
ENV PGQ_SHA256 835b6521e858795e3199e4ba0253f52e0ab1985e38f11f201e6994d4b5eff1a5
ENV PGQD_SHA256 a666e5e735f093ef09823ef0df1ba562b52e8fc9081ba1c8b3c3d662658f4916


RUN set -eux \
    \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        tar \
    \
# get PGQ
    \
    && wget -O pgq.tar.gz "https://github.com/pgq/pgq/releases/download/v${PGQ_VERSION}/pgq-${PGQ_VERSION}.tar.gz" \
    && echo "${PGQ_SHA256} *pgq.tar.gz" | sha256sum -c - \
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
    && wget -O pgqd.tar.gz "https://github.com/pgq/pgqd/releases/download/v${PGQ_VERSION}/pgqd-${PGQ_VERSION}.tar.gz" \
    && echo "${PGQD_SHA256} *pgqd.tar.gz" | sha256sum -c - \
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
        clang-dev \
        g++ \
        gcc \
        libevent-dev \
        llvm-dev \
        make \
        python3-dev \
        py3-docutils \
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
        libevent \
        libstdc++ \
        python3 \
        ca-certificates \
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

COPY ./initdb-pgq.sh /docker-entrypoint-initdb.d/10_pgq.sh
COPY ./update-pgq.sh /usr/local/bin
COPY docker-entrypoint-pgq.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint-pgq.sh"]
CMD ["postgres"]
