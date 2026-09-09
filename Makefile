NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all: setup
	$(COMPOSE) up -d --build

setup:
	mkdir -p ~/home/data
	mkdir -p ~/home/amzahir/data/wordpress
	mkdir -p ~/home/amzahir/data/mariadb

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down
logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af
	sudo rm -rf ~/home/amzahir/data
re: fclean all