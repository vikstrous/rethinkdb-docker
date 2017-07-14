ORG?=jlhawn
PROJ?=rethinkdb
DOCKER_TAG?=2.4.0-cfee565
GIT_HASH?=cfee565ebb0a1db07619c9008a9b8b37e21be166

image:

	# Build the rethinkdb-build image.
	docker build --build-arg GIT_HASH=$(GIT_HASH) -t rethinkdb-build -f Dockerfile.build .

	# Create a container from that image, copy out the built RethinkDB binary
	# into the local bin directory, and remove the container.
	docker rm -f rethinkdb-build || true
	docker create --name rethinkdb-build rethinkdb-build
	docker cp rethinkdb-build:/usr/local/bin/rethinkdb .
	docker rm rethinkdb-build

	# Build the minimal image.
	docker build -t $(ORG)/$(PROJ):$(DOCKER_TAG) -f Dockerfile.min .

push:

	docker push $(ORG)/$(PROJ):$(DOCKER_TAG)
