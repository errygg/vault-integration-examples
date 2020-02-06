.PHONY: all build

all: build

build:
	docker build --no-cache -t errygg/app-build:build -f ./build/docker/Dockerfile.build .
	docker create --name extract errygg/app-build:build
	docker cp extract:/go/src/github.com/errygg/app/app ./bin/app
	docker rm -f extract
	docker build --no-cache -t app -f ./build/docker/Dockerfile .
	docker tag app errygg/app:0.0.1
