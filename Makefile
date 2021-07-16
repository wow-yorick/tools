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

export MVNW_VERBOSE=true
export MVNW_REPOURL=https://maven.aliyun.com/repository/public

ebs_id = $(shell docker ps -a |grep ccb-ebs:0.1 | awk '{print $$1}')

.PHONY: up
up: docker-rmi build docker-build docker-run docker-ps

.PHONY: id
id:
	echo $(ebs_id)

.PHONY: build
build:
	./mvnw clean package -Dmaven.test.skip=true

.PHONY: docker-build
docker-build:
	docker build -t test/ccb-ebs:0.1 .

.PHONY: docker-run
docker-run:
	docker run -p 8080:80 -itd --name ccb-ebs test/ccb-ebs:0.1

.PHONY: docker-stop
docker-stop:
	docker stop $(ebs_id)

.PHONY: docker-start
docker-start:
	docker start $(ebs_id)

.PHONY: docker-restart
docker-restart:
	docker restart $(ebs_id)

.PHONY: docker-rm
docker-rm: docker-stop
	docker rm ccb-ebs

.PHONY: docker-rmi
docker-rmi: docker-stop docker-rm
	docker rmi test/ccb-ebs:v0.1

.PHONY: docker-ps
docker-ps:
	docker ps | grep ccb-ebs

.PHONY: test
test: build
	cp  target/*.jar app.jar
	java -jar app.jar

