# Makefile for managing the Docker Compose lifecycle

# Use your docker-compose file (default docker-compose.yml)
COMPOSE=docker-compose -f srcs/docker-compose.yml

.PHONY: build up down restart logs clean

# Build images
build:
	$(COMPOSE) build

# Start containers in detached mode
up:
	$(COMPOSE) up -d

# Stop containers
down:
	$(COMPOSE) down

# Restart containers
restart: down up

# View logs (follow)
logs:
	$(COMPOSE) logs -f

# Clean up unused Docker images and volumes
clean:
	$(COMPOSE) down --volumes --rmi all
	docker system prune -f



#make build — Build your images
#make up — Start your services in the background
#make down — Stop your services
#make restart — Restart your services
#make logs — Show and follow logs
#make clean — Remove containers, volumes, images, and prune dangling resources*/