# Makefile for managing the Docker Compose lifecycle

COMPOSE=docker-compose -f srcs/docker-compose.yml

.PHONY: build up down restart logs clean clean_full

# Build all images
build:
	$(COMPOSE) build

# Start all services
up:
	$(COMPOSE) up -d

# Stop all services
down:
	$(COMPOSE) down

# Restart all services
restart: down up

# Show logs (follow mode)
logs:
	$(COMPOSE) logs -f

# Clean: remove containers, volumes, and images from docker-compose only
clean:
	$(COMPOSE) down --volumes --rmi all
	docker system prune -f

# 🔥 Clean FULL: Remove everything including local DB/site folders
clean_full:
	$(COMPOSE) down --volumes --rmi all
	docker volume prune -f
	docker network prune -f
	docker image prune -af
	docker container prune -f
	docker system prune -af
	sudo rm -rf /home/$(USER)/data/mariadb
	sudo rm -rf /home/$(USER)/data/wordpress
	mkdir /home/$(USER)/data/wordpress
	mkdir /home/$(USER)/data/mariadb

