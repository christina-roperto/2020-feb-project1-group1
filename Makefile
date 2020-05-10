#Makefile
COMPOSE_RUN = docker-compose build && docker-compose run --rm tf012aws2

#.SILENT

.PHONY: prepare plan build deploy clean cmurlshell

all: plan build deploy

prepare:
	export AWS_ACCESS_KEY_ID ?= ${{ secrets.AWS_ACCESS_KEY_ID }}
	export AWS_SECRET_ACCESS_KEY ?= ${{ secrets.AWS_SECRET_ACCESS_KEY }}
	if [ ! -f .env ]; then cp -v .env.example .env ; fi
	git rev-parse --short HEAD > repo_version.txt

plan:
	make prepare
	$(COMPOSE_RUN) make _plan

_plan:
	bash -x scripts/plan_ecr.sh
	bash -x scripts/plan_aws.sh

build:
	$(COMPOSE_RUN) make _build
	bash -x scripts/push_image.sh

_build:
	bash -x scripts/apply_ecr.sh

deploy:
	$(COMPOSE_RUN) make _deploy

_deploy:
	bash -x scripts/plan_aws.sh
	bash -x scripts/apply_aws.sh

destroy:
	$(COMPOSE_RUN) make _destroy

_destroy:
	bash -x scripts/destroy.sh

clean:
	docker-compose down -v
	make _clean

_clean:
	bash -x scripts/clean.sh

shell:
	$(COMPOSE_RUN)
