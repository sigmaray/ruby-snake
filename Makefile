.PHONY: docker-build
docker-build:
	docker build -t ruby-snake .

.PHONY: docker-run
docker-run:
	docker run -it -p 8080:8080 ruby-snake

.PHONY: docker-build-and-run
docker-build-and-run:
	docker build -t ruby-snake . && docker run -it -p 8080:8080 ruby-snake
