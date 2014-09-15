# XXX no versioning of the docker image

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build:
	docker build ${NOCACHEFLAG} -t planitar/userdb .

push:
	docker push planitar/userdb

clean:
	docker rmi -f planitar/userdb || true

test:
	docker run --name test-userdb -d planitar/userdb
	sleep 3s
	addr=$$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' test-userdb) && \
	  psql -d userdb -h $$addr -U user_api -f test.sql; ret=$$?; \
	  if [ $$ret -ne 0 ]; then \
		docker logs test-userdb; \
		docker stop test-userdb; \
		docker rm test-userdb; \
		false; \
	  fi
	docker stop test-userdb
	docker rm test-userdb
