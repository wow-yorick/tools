EXTIEDDOCKER := $(shell docker ps -qf status=exited)
BLACK = "\033[30;1m"

RED  =  "\033[41;36m"

GREEN = "\033[32;1m"

YELLOW = "\033[33;1m"

BLUE  = "\033[34;1m"

PURPLE = "\033[35;1m"

CYAN  = "\033[36;1m"

WHITE = "\033[37;1m"

BLOCKEND = "\033[0m"

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

ID = $(shell docker ps -a |grep ccb-ebs:0.1 | awk '{print $$1}')

.PHONY: up
up: docker-rmi build docker-build docker-run docker-ps

.PHONY: id
id:
	echo $(ID)

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

.PHONY: media
media: sync-media
	open /Applications/*Typora*

.PHONY: logseq
logseq: sync-articles
	open /Applications/*Logseq*

.PHONY: emacs
emacs:
	@echo $(GREEN)"begin sync emacs"$(BLOCKEND)
	-cd ~/.emacs.d && git pull && git fetch update_stream && git merge update_stream/master && git push
	@echo $(GREEN)"finish sync emacs"$(BLOCKEND)
	@echo ""

.PHONY: sync-media
sync-media:
	@echo $(GREEN)"begin sync we-media"$(BLOCKEND)
	-cd ~/workspace/wowyorick-we-media && git add . && (git commit -a -m 'feat: media') ; git pull ; git push
	@echo $(GREEN)"finish sync we-media"$(BLOCKEND)
	@echo ""

.PHONY: sync-articles
sync-articles:
	@echo $(GREEN)"begin sync articles"$(BLOCKEND)
	-cd ~/workspace/articles && (git add . && git commit -a -m 'feat: 日记');git pull && git push
	@echo $(GREEN)"finish sync articles"$(BLOCKEND)
	@echo ""

.PHONY: sync-all
sync-all: sync-media sync-articles emacs

.PHONY: publish
publish:
	@echo $(GREEN)"start publish"$(BLOCKEND)
	cd ~/workspace/wow-yorick.github.io && git pull
	cd ~/workspace/blog/ && hugo
	rm -fr ~/workspace/wow-yorick.github.io/*
	cp -r ~/workspace/blog/public/. ~/workspace/wow-yorick.github.io
	echo "www.5zyx.com" > ~/workspace/wow-yorick.github.io/CNAME
	cd ~/workspace/wow-yorick.github.io && git add . && git commit -a -m 'publish blog' && git push
	@echo $(GREEN)"finish publish"$(BLOCKEND)
	@echo ""

