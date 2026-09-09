*This project has been created as part of the 42 curriculum by amzahir.*

# Description

Inception is a system administration project focused on Docker and containerization.

The goal is to build a small infrastructure using Docker Compose, with separate containers for each service.

The project contains:

* NGINX — web server and HTTPS entry point.
* WordPress — website and PHP application.
* MariaDB — database used by WordPress.

Docker Compose is used to build, connect, and manage the different services.
### Docker

Docker is used to run each service in an isolated container. Each service has its own Dockerfile and is connected through a Docker network.

The project contains:

- NGINX — web server and HTTPS entry point.
- WordPress — website and PHP application.
- MariaDB — database used by WordPress.
- Redis — object cache for WordPress.
- Adminer — web interface for managing the MariaDB database.

The main design choices are:

- One service per container.
- Debian-based images.
- NGINX handles HTTPS traffic.
- Named volumes are used to persist WordPress and MariaDB data.
- Environment variables and secrets are used for configuration and credentials.

### Virtual Machines vs Docker

A virtual machine contains a complete operating system and virtual hardware. Docker containers share the host kernel and isolate applications instead.

Docker containers are generally lighter and faster to start, while virtual machines provide stronger OS-level isolation.

### Secrets vs Environment Variables

Environment variables are convenient for configuration values such as usernames and database names.

Secrets are intended for sensitive information such as passwords. They avoid exposing credentials directly through normal environment configuration.

Environment variables are used for configuration and WordPress credentials, while Docker secrets are used for sensitive database credentials.
### Docker Network vs Host Network

A Docker network provides isolated communication between containers. Services can communicate using their container/service names.

Host networking removes this network isolation and makes the container use the host's network directly.

This project uses a Docker network because the services only need to communicate with each other and expose HTTPS through NGINX.

### Docker Volumes vs Bind Mounts

A Docker volume is managed by Docker and is independent of a specific host directory.

A bind mount directly maps a host filesystem path into a container.

This project uses volumes for persistent WordPress and MariaDB data, allowing the data to survive container recreation.

# Instructions

## Prerequisites

* Docker
* Docker Compose
* Make

## Setup

Create the required data directories:

```bash
make setup
```

Configure the required environment variables and secrets according to the project configuration.

## Build and start

```bash
make
```

or:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

The website is available through HTTPS on port 443.

## Stop

```bash
docker compose -f srcs/docker-compose.yml stop
```

To stop and remove the containers and network:

```bash
docker compose -f srcs/docker-compose.yml down
```

# Resources

### Documentation

- Hackr.io — What is Docker?: https://hackr.io/blog/what-is-docker
* Docker Documentation: https://docs.docker.com/
* Docker Compose Documentation: https://docs.docker.com/compose/
* NGINX Documentation: https://nginx.org/en/docs/
* MariaDB Documentation: https://mariadb.com/docs/
* WordPress Documentation: https://developer.wordpress.org/

### AI Usage

AI was used as a learning and debugging assistant during the project.

It was used to:

* Explain Docker and Docker Compose concepts.
* Understand Dockerfiles, images, layers, networks, and volumes.
* Help debug configuration and startup errors.
* Explain commands and configuration options.
* Help investigate service communication and permissions.

The project configuration and implementation were tested and adapted manually.

