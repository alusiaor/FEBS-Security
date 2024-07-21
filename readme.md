```shell

docker run  -u root   -d  -p 49999:8080 -p 50001:50000 -v /Users/docker/docker_jenkins:/var/jenkins_home  -v /var/run/docker.sock:/var/run/docker.sock  --name jenkins  jenkins/jenkins:lts-jdk11
```