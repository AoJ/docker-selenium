NAME=aooj/selenium
VERSION=1.0


build:
	docker build --rm -t $(NAME):$(VERSION) .


run:
	docker run --rm -t -i $(NAME):$(VERSION) sh


debug: build
	docker run --rm -t -i $(NAME):$(VERSION) /bin/sh


.PHONY: build run debug
