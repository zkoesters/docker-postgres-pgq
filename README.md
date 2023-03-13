# zkoesters/postgres-pgq

The `zkoesters/postgres-pgq` image provides tags for running Postgres with the [PGQ](https://github.com/pgq/pgq) extension installed. This image is based on the official [`postgres`](https://registry.hub.docker.com/_/postgres/) image and provides debian and alpine variants for PGQ 3.5 for each supported version of Postgres (11, 12, 13, 14 and 15).

This image ensures that the default database created by the parent `postgres` image will have the following extensions installed:

* `pgq`

Unless `-e POSTGRES_DB` is passed to the container at startup time, this database will be named after the admin user (either `postgres` or the user specified with `-e POSTGRES_USER`). If you would prefer to use the older template database mechanism for enabling PostGIS, the image also provides a PGQ-enabled template database called `template_pgq`.

# Versions ( 2023-03-11 )

Recomended version for the new users: `zkoesters/postgres-pgq:15-3.5`

### Debian based ( recommended ):

* PGQ from debian repository
* Easy to extend, matured

| DockerHub image | Dockerfile | OS | Postgres | PGQ |
| --------------- | ---------- | -- | -------- | --- |
| [zkoesters/postgres-pgq:11-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=11-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/11-3.5/Dockerfile) | debian:bullseye | 11 | 3.5 |
| [zkoesters/postgres-pgq:12-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=12-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/12-3.5/Dockerfile) | debian:bullseye | 12 | 3.5 |
| [zkoesters/postgres-pgq:13-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=13-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/13-3.5/Dockerfile) | debian:bullseye | 13 | 3.5 |
| [zkoesters/postgres-pgq:14-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=14-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/14-3.5/Dockerfile) | debian:bullseye | 14 | 3.5 |
| [zkoesters/postgres-pgq:15-3.5](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=15-3.5) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/15-3.5/Dockerfile) | debian:bullseye | 15 | 3.5 |

### Alpine based

* base os = [Alpine linux](https://alpinelinux.org/): designed to be small, simple and secure ; [musl libc](https://musl.libc.org/) based
* alpine:3.17; pgq=3.5
* PGQ has been compiled from source ; harder to extend

| DockerHub image | Dockerfile | OS | Postgres | PGQ |
| --------------- | ---------- | -- | -------- | --- |
| [zkoesters/postgres-pgq:11-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=11-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/11-3.5/alpine/Dockerfile) | alpine:3.17 | 11 | 3.5 |
| [zkoesters/postgres-pgq:12-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=12-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/12-3.5/alpine/Dockerfile) | alpine:3.17 | 12 | 3.5 |
| [zkoesters/postgres-pgq:13-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=13-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/13-3.5/alpine/Dockerfile) | alpine:3.17 | 13 | 3.5 |
| [zkoesters/postgres-pgq:14-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=14-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/14-3.5/alpine/Dockerfile) | alpine:3.17 | 14 | 3.5 |
| [zkoesters/postgres-pgq:15-3.5-alpine](https://registry.hub.docker.com/r/zkoesters/postgres-pgq/tags?page=1&name=15-3.5-alpine) | [Dockerfile](https://github.com/zkoesters/docker-postgres-pgq/blob/master/15-3.5/alpine/Dockerfile) | alpine:3.17 | 15 | 3.5 |

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
