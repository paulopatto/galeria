app_name = "paulopatto/galeria"

build:
	@docker build -t $(app_name):development .

run:
	docker run --detach -p 9000:9000 $(app_name):development

kill:
	@echo 'Killing container...'
	@docker ps | grep $(app_name) | awk '{print $$1}' | xargs docker stop

deploy_image:
	@docker build -t $(app_name):$(git rev-parse --short HEAD)
	@docker push $(app_name):$(git rev-parse --short HEAD)

deploy_latest_image:
	@docker build -t $(app_name):latest
	@docker push $(app_name):latest

