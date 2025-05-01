COMPOSE_FILE   := srcs/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

DATADIR := ~/data
MARIADB := $(DATADIR)/mariadb
WORDPRESS := $(DATADIR)/wordpress

all: up

up:  setup $(MARIADB) $(WORDPRESS)
	@$(DOCKER_COMPOSE) up --build -d

down:
	@$(DOCKER_COMPOSE) down

re: down up

clean:
	@$(DOCKER_COMPOSE) down -v --rmi all

fclean: clean
	sudo rm -rf $(SECRETS_DIR)
	sudo rm -rf $(DATADIR)

ps:
	@$(DOCKER_COMPOSE) ps

logs:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		$(DOCKER_COMPOSE) logs; \
	else \
		SVC=$(filter-out $@,$(MAKECMDGOALS)) && \
		$(DOCKER_COMPOSE) logs $$SVC; \
	fi

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

### ─────────────────────  secrets bootstrap  ──────────────────────
SECRETS_DIR      = ./secrets
SECRETS_SENTINEL := $(SECRETS_DIR)/.generated   # “done” stamp

setup: $(SECRETS_SENTINEL)

$(SECRETS_SENTINEL): srcs/setup.sh
	@echo ">> running interactive setup to create secrets"
	./srcs/setup.sh
	@touch $(SECRETS_SENTINEL)

.PHONY: all up down re clean fclean ps logs volumes setup
