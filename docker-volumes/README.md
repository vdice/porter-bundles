## Overview

A Porter bundle that utilizes [Docker Volumes](https://docs.docker.com/storage/volumes/) for getting data into/out of a Docker Compose application.

It uses a proper Docker Volume for mounting data from the application directory (`/cnab/app`) into the Docker Compose app container (at `/data`).  In this example, it is the `echo.txt` file that is created from the corresponding bundle parameter `echo_text` value.

It uses a [bind mount](https://docs.docker.com/storage/bind-mounts/) volume to mount data from the Docker Compose app container (from `/logs`) to the host running the bundle (at the value provided by the required bundle parameter `docker_host_volume`).

## Sample Flow:

```
 $ porter install --allow-docker-host-access \
  --param docker_host_volume=/Users/vdice/scratch/dockervolume
installing docker-host-volumes...
executing install action from docker-host-volumes (installation: docker-host-volumes)
Create Docker volumes
cnab-app-volume
docker-host-volume
Creating network "app_default" with the default driver
Creating app_hello_1 ... done
Print app logs
Hello from Porter!
execution completed successfully!

 $ porter upgrade --allow-docker-host-access \
  --param docker_host_volume=/Users/vdice/scratch/dockervolume \
  --param echo_text="Howdy from Porter!"
upgrading docker-host-volumes...
executing upgrade action from docker-host-volumes (installation: docker-host-volumes)
Update Docker volumes
local     cnab-app-volume
local     docker-host-volume
Starting app_hello_1 ... done
Print app logs
Howdy from Porter!
execution completed successfully!

 $ porter uninstall --allow-docker-host-access
uninstalling docker-host-volumes...
executing uninstall action from docker-host-volumes (installation: docker-host-volumes)
Removing app_hello_1 ... done
Removing network app_default
Remove Docker volumes
cnab-app-volume
docker-host-volume
execution completed successfully!
```
