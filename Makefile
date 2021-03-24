EXTIEDDOCKER := $(shell docker ps -qf status=exited)

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  up                  Build and Run nginx and php"
	@echo "  stop                Stop nginx and php"
	@echo "  start               Run nginx and php"
	@echo "  restart             Restart nginx and php"
	@echo "  ps                  docker ps -a"
	@echo "  ls                  docker images"
	@echo "  rmi                 Remove tag is <none> images"
	@echo "  logs                Follow log output"
	@echo "  cli                 make appcli"

up:
	@docker-compose up -d

stop:
	@docker-compose stop

rm:
	@docker-compose rm

start:
	@docker-compose start

restart:
	@docker-compose restart

ps:
	@docker ps -a

ls:
	@docker images

rmi:
	@docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi

rmc:
	@docker rm ${EXTIEDDOCKER}

logs:
	@docker-compose logs -f

