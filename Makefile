NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml

all:
$(COMPOSE) up -d --build

build:
$(COMPOSE) build

up:
$(COMPOSE) up -d

down:
$(COMPOSE) down

clean:
$(COMPOSE) down -v

fclean: clean
docker system prune -af

re: fclean all
