
```console
$ export MY_SECRET="this is my secret"

$ echo "this is my host secret" > /tmp/my_host_secret.txt

$ export PORTER_ALLOW_DOCKER_HOST_ACCESS=true

$ porter creds generate
Generating new credential compose-example from bundle compose-example
==> 1 credentials required for bundle compose-example
? How would you like to set credential "docker_secret" environment variable
? Enter the environment variable that will be used to set credential "docker_secret" MY_SECRET

$ porter install -c compose-example
installing compose-example...
executing install action from compose-example (bundle instance: compose-example)
Create a docker secret
vsy1mljatp9ip4h8s3llkvq4q
Docker compose up
Service "web" uses an undefined secret file "/tmp/my_host_secret.txt", the following file should be created "/tmp/my_host_secret.txt"
Service "web" uses secret "my_created_secret" which is external. External secrets are not available to containers created by docker-compose.
The Docker Engine you're using is running in swarm mode.

Compose does not use swarm mode to deploy services to multiple nodes in a swarm. All containers will be scheduled on the current node.

To deploy your application across the swarm, use `docker stack deploy`.

app_redis_1 is up-to-date
Recreating app_web_1 ... done
execution completed successfully!

$ docker logs app_web_1
this is my host secret
cat: /run/secrets/my_created_secret: No such file or directory
```