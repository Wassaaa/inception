COMPOSE_FILE   := srcs/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

DATADIR := ~/data
MARIADB := $(DATADIR)/mariadb
WORDPRESS := $(DATADIR)/wordpress

all: up

up: $(MARIADB) $(WORDPRESS)
	@$(DOCKER_COMPOSE) up --build -d

down:
	@$(DOCKER_COMPOSE) down

re: down up

clean:
	@$(DOCKER_COMPOSE) down -v --rmi all

fclean: clean
	sudo rm -rf $(DATADIR)

ps:
	@$(DOCKER_COMPOSE) ps

logs:
	@$(DOCKER_COMPOSE) logs

volumes:
	docker volume ls
	docker volume inspect srcs_mariadb
	docker volume inspect srcs_wordpress

run:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make run <service>"; \
	else \
		SVC=$(filter-out $@,$(MAKECMDGOALS)) && \
		$(DOCKER_COMPOSE) run --rm $$SVC ash; \
	fi

exec:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make debug <service>"; \
	else \
		SVC=$(filter-out $@,$(MAKECMDGOALS)) && \
		$(DOCKER_COMPOSE) exec -it $$SVC ash; \
	fi

# Prevent 'wordpress' from being treated as a target
%:
	@:

$(MARIADB) $(WORDPRESS):
	mkdir -p $@

.PHONY: all up down re clean fclean ps logs volumes
