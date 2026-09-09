# User Documentation

## Services

The project provides five services:

* NGINX: HTTPS web server and entry point.
* WordPress: website and administration interface.
* MariaDB: database used by WordPress.
* Redis: object cache used by WordPress to improve performance.
* Adminer: web interface for managing the MariaDB database.

## Start the project

From the project root:

```bash
make
```

The services will be built and started in the background.

## Stop the project

To stop the containers without removing them:

```bash
docker compose -f srcs/docker-compose.yml stop
```

To stop and remove the containers:

```bash
docker compose -f srcs/docker-compose.yml down
```

Docker images and persistent volumes are not removed by `stop` or `down`.

## Access the website

Open:

```text
https://amzahir.42.fr
```

The WordPress administration panel is available at:

```text
https://amzahir.42.fr/wp-admin
```

## Credentials

WordPress credentials are stored in the `.env` file.

Database passwords are stored as Docker secrets in the `secrets/` directory.

Do not commit either `.env` or the contents of `secrets/` to Git.

## Check the services

Check running containers:

```bash
docker compose -f srcs/docker-compose.yml ps
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

A healthy stack should have all five containers running.

The website can also be tested with:

```bash
curl -k https://amzahir.42.fr
```

## Access Adminer

Adminer is available through its configured URL and port.

When logging in:

* System: MySQL
* Server: `mariadb`
* Username: the configured MariaDB user
* Password: the configured MariaDB password
* Database: the configured WordPress database
