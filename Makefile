NAME=dockage/debian
VERSION?=$(shell cat VERSION)

brew:
	sudo ./brew.sh

build:
	sudo docker build -t $(NAME):$(VERSION) .

release:
	docker push $(NAME):$(VERSION)
