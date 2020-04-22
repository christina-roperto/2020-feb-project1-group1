#Makefile
COMPOSE_RUN = docker-compose run --rm terraform

#.SILENT

.PHONY: plan build deploy

all: plan build deploy

plan:
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
	bash -x scripts/apply_aws.sh

destroy:
	$(COMPOSE_RUN) make _destroy

_destroy:
	bash -x scripts/destroy.sh

clean:
	docker-compose down -v --rmi all --remove-orphans
	@make _clean

_clean:
	bash -x scripts/clean.sh