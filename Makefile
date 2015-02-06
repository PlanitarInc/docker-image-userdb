# XXX no versioning of the docker image
IMAGE_NAME=planitar/userdb

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build:
	docker build ${NOCACHEFLAG} -t ${IMAGE_NAME} .

push:
	docker push ${IMAGE_NAME}

clean:
	docker rmi -f ${IMAGE_NAME} || true

test:
	docker run --name test-userdb -d ${IMAGE_NAME}
	sleep 3s
	addr=$$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' test-userdb) && \
	docker run --rm -v `pwd`:/in ${IMAGE_NAME} \
	  psql -d userdb -h $$addr -U user_api -f /in/test.sql; ret=$$?; \
	  if [ $$ret -ne 0 ]; then \
		docker logs test-userdb; \
		docker stop test-userdb; \
		docker rm test-userdb; \
		false; \
	  fi
	docker stop test-userdb
	docker rm test-userdb
