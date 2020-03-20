Example bundle utilizing jdolitsky's work in https://github.com/deislabs/porter/pull/951

```console
 $ PORTER_ALLOW_DOCKER_HOST_ACCESS=true porter install
installing composerator...
executing install action from composerator (bundle instance: composerator)
Docker compose up
Creating network "compose_default" with the default driver
Building web
Step 1/1 : FROM nginx
 ---> 6678c7c2e56c
Successfully built 6678c7c2e56c
Successfully tagged compose_web:latest
Image for service web was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating compose_redis_1 ... done
Creating compose_web_1   ... done
execution completed successfully!

 $ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
32d19346bd3a        redis:alpine        "docker-entrypoint.s…"   5 seconds ago       Up 4 seconds        6379/tcp               compose_redis_1
b2cdd6629b2c        compose_web         "nginx -g 'daemon of…"   5 seconds ago       Up 4 seconds        0.0.0.0:8000->80/tcp   compose_web_1

 $ PORTER_ALLOW_DOCKER_HOST_ACCESS=true porter uninstall
uninstalling composerator...
executing uninstall action from composerator (bundle instance: composerator)
Docker compose down
Stopping compose_redis_1 ... done
Stopping compose_web_1   ... done
Removing compose_redis_1 ... done
Removing compose_web_1   ... done
Removing network compose_default
execution completed successfully!

 $ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```