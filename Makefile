# XXX no versioning of the docker image

.PHONY: build push clean test

build:
	docker build -t planitar/userdb .

push:
	docker push planitar/userdb

clean:
	docker rmi -f planitar/userdb

test:
	docker run --name userdb -d planitar/userdb
	sleep 3s
	addr=$$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' userdb) && \
	  psql -d userdb -h $$addr -U user_api -l; ret=$$?; \
	  if [ $$ret -ne 0 ]; then \
		docker logs userdb; \
		docker stop userdb; \
		docker rm userdb; \
		false; \
	  fi
	docker stop userdb
	docker rm userdb
