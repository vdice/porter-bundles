A WIP Porter bundle exploring some options of getting data into/out of a Docker Compose application.

Sample:

```
 $ porter install --allow-docker-host-access
installing docker-app...
executing install action from docker-app (installation: docker-app)
Create Docker volume
+ create_docker_volume
+ docker volume ls
+ grep myvol
+ docker volume create myvol
myvol
+ docker run -v myvol:/data --name helper busybox true
+ docker cp /cnab/app/echo.txt helper:/data
+ docker cp /cnab/app/config.toml helper:/data
+ docker rm helper
helper
Creating app_hello_1 ... done
Print app logs
+ print_app_logs
+ docker logs app_hello_1
config.toml
echo.txt
hello from porter!
execution completed successfully!
```

Overriding the `echo_text` param:

```
 $ porter install --allow-docker-host-access --param echo_text="Howdy from porter!"
installing docker-app...
executing install action from docker-app (installation: docker-app)
Create Docker volume
+ create_docker_volume
+ grep myvol
+ docker volume ls
+ docker volume create myvol
myvol
+ docker run -v myvol:/data --name helper busybox true
+ docker cp /cnab/app/echo.txt helper:/data
+ docker cp /cnab/app/config.toml helper:/data
+ docker rm helper
helper
Creating app_hello_1 ... done
Print app logs
+ print_app_logs
+ docker logs app_hello_1
config.toml
echo.txt
Howdy from porter!
execution completed successfully!
```