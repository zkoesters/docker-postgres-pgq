# zkoesters/postgres-pgq

The `zkoesters/postgres-pgq` image provides tags for running Postgres with the [PGQ](https://github.com/pgq/pgq) extension installed. This image is based on the official [`postgres`](https://registry.hub.docker.com/_/postgres/) image and provides debian and alpine variants for PGQ 3.5 for each supported version of Postgres (13, 14, 15, 16 and 17).

This image ensures that the default database created by the parent `postgres` image will have the following extensions installed:

* `pgq`

Unless `-e POSTGRES_DB` is passed to the container at startup time, this database will be named after the admin user (either `postgres` or the user specified with `-e POSTGRES_USER`). If you would prefer to use the older template database mechanism for enabling PostGIS, the image also provides a PGQ-enabled template database called `template_pgq`.

# Versions ( 2024-11-22 )

Recomended version for the new users: `zkoesters/postgres-pgq:17-3.5`

### Debian based ( recommended ):

* PGQ from debian repository
* Easy to extend, matured

| DockerHub image | Dockerfile | OS | Postgres | PGQ |
| --------------- | ---------- | -- | -------- | --- |
| [zkoesters/postgres-pgq:13-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=13-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/13-3.5/Dockerfile) | debian:bookworm | 13 | 3.5 |
| [zkoesters/postgres-pgq:14-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=14-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/14-3.5/Dockerfile) | debian:bookworm | 14 | 3.5 |
| [zkoesters/postgres-pgq:15-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=15-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/15-3.5/Dockerfile) | debian:bookworm | 15 | 3.5 |
| [zkoesters/postgres-pgq:16-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=16-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/16-3.5/Dockerfile) | debian:bookworm | 16 | 3.5 |
| [zkoesters/postgres-pgq:17-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=17-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/17-3.5/Dockerfile) | debian:bookworm | 17 | 3.5 |

### Alpine based

* base os = [Alpine linux](https://alpinelinux.org/): designed to be small, simple and secure ; [musl libc](https://musl.libc.org/) based
* alpine:3.20; pgq=3.5.1
* PGQ has been compiled from source ; harder to extend

| DockerHub image | Dockerfile | OS          | Postgres | PGQ   |
| --------------- | ---------- |-------------| -------- |-------|
| [zkoesters/postgres-pgq:13-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=13-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/13-3.5/alpine/Dockerfile) | alpine:3.20 | 13 | 3.5.1 |
| [zkoesters/postgres-pgq:14-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=14-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/14-3.5/alpine/Dockerfile) | alpine:3.20 | 14 | 3.5.1 |
| [zkoesters/postgres-pgq:15-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=15-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/15-3.5/alpine/Dockerfile) | alpine:3.20 | 15 | 3.5.1 |
| [zkoesters/postgres-pgq:16-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=16-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/16-3.5/alpine/Dockerfile) | alpine:3.20 | 16 | 3.5.1 |
| [zkoesters/postgres-pgq:17-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=17-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/17-3.5/alpine/Dockerfile) | alpine:3.20 | 17 | 3.5.1 |

## Usage

In order to run a basic container capable of serving a PGQ-enabled database, start a container as follows:

    docker run --name some-pgq -e POSTGRES_PASSWORD=mysecretpassword -d zkoesters/postgres-pgq

For more detailed instructions about how to start and control your Postgres container, see the documentation for the `postgres` image [here](https://registry.hub.docker.com/_/postgres/).

Once you have started a database container, you can then connect to the database either directly on the running container:

    docker exec -ti some-pgq psql -U postgres

... or starting a new container to run as a client. In this case you can use a user-defined network to link both containers:

    docker network create some-network

    # Server container
    docker run --name some-pgq --network some-network -e POSTGRES_PASSWORD=mysecretpassword -d zkoesters/postgres-pgq

    # Client container
    docker run -it --rm --network some-network zkoesters/postgres-pgq psql -h some-pgq -U postgres

Check the documentation on the [`postgres` image](https://registry.hub.docker.com/_/postgres/) and [Docker networking](https://docs.docker.com/network/) for more details and alternatives on connecting different containers.
