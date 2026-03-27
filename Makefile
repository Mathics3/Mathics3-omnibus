# A GNU Makefile to run various tasks - compatibility for us old-timers.

# Note: This makefile include remake-style target comments.
# These comments before the targets start with #:
# remake --tasks to shows the targets and the comments

DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose
DOCKER_COMPOSE_FILE =
GIT2CL ?= admin-tools/git2cl
RM  ?= rm
TAG ?= latest

.PHONY: all \
   check clean \
   dist \
   docker-image \
   docker-image-quick \
   push \
   rmChangeLog \
   test \
   upload

SANDBOX	?=
ifeq ($(OS),Windows_NT)
	SANDBOX = t
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		SANDBOX = t
	endif
endif

#: Default target - same as "develop"
all: docker-image

#: Make distribution: wheels, eggs, tarball
dist:
	./admin-tools/make-dist.sh

#: Pull mathics docker image from dockerhub with tag $(TAG). The default tag is "latest".
docker-pull:
	$(DOCKER) pull mathicsorg/mathics3:$(TAG)

#: Push local docker image to dockerhub with tag $(TAG). The default tag is "latest".
install push upload:
	$(DOCKER) push mathicsorg/mathics3:$(TAG)

#: Build docker image with cache clearing
docker-image:
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_FILE) build --no-cache

#: Build docker image without clearing cache
docker-image-quick:
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_FILE) build

# check: pytest gstest

#: Remove derived files
clean:
	rm mathics/*/*.so; \
	for dir in mathics/doc ; do \
	   ($(MAKE) -C "$$dir" clean); \
	done;

#: Remove ChangeLog
rmChangeLog:
	$(RM) ChangeLog || true

#: Create a ChangeLog from git via git log and git2cl
ChangeLog: rmChangeLog
	git log --pretty --numstat --summary | $(GIT2CL) >$@
	patch ChangeLog < ChangeLog-spell-corrected.diff
