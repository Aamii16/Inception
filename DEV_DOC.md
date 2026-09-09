# Developer Documentation

## Prerequisites

Install:

* Docker
* Docker Compose
* Make

The project should be run on a Linux environment with the required permissions to use Docker.

## Project configuration

The Docker Compose configuration is located at:

```text
srcs/docker-compose.yml
```

The project contains five services:

* NGINX — HTTPS web server.
* WordPress — PHP application and website.
* MariaDB — WordPress database.
* Redis — WordPress object cache.
* Adminer — database management interface.

Each service has its own configuration. Custom Dockerfiles are used where required.
Sensitive configuration is stored locally.

- `.env` contains WordPress credentials and other environment variables.
- `secrets/` contains database passwords used by Docker secrets.

These files must be created locally and must not be committed to Git.

## Setup

Create the persistent data directories:

```bash
make setup
```

Review the environment and secret configuration before starting the project.

## Build and launch

Using the Makefile:

```bash
make
```

Using Docker Compose directly:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

## Container management

List containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Stop containers:

```bash
docker compose -f srcs/docker-compose.yml stop
```

Start stopped containers:

```bash
docker compose -f srcs/docker-compose.yml start
```

Stop and remove containers:

```bash
docker compose -f srcs/docker-compose.yml down
```

Rebuild images:

```bash
docker compose -f srcs/docker-compose.yml build
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

View logs for a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
docker compose -f srcs/docker-compose.yml logs redis
docker compose -f srcs/docker-compose.yml logs adminer
```

## Volumes

The project uses persistent Docker volumes for WordPress and MariaDB data.

List volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

Persistent volumes allow data to survive container recreation.

Do not remove the volumes unless the stored data is no longer needed.


## Data persistence

The main persistent data consists of:

* MariaDB database data.
* WordPress website data.

The data is stored outside the container's temporary writable layer through Docker volumes.

Removing and recreating a container does not remove its associated persistent volume unless the volume is explicitly deleted.

To remove the project's volumes:

```bash
docker compose -f srcs/docker-compose.yml down -v
```

This deletes the project's volumes and therefore its persistent data.

