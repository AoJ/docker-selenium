NAME=aooj/selenium
VERSION=1.0


build:
	docker build -t $(NAME):$(VERSION) .


run:
	docker run -t -i $(NAME):$(VERSION)


debug: build
	docker run --rm -t -i $(NAME):$(VERSION) /bin/bash	


.PHONY: build run debug
