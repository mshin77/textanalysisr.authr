## On the Local Server
```
docker build -t mshin77/textanalysisr.authr .
docker tag  mshin77/textanalysisr.authr  mshin77/textanalysisr.authr
docker push  mshin77/textanalysisr.authr:latest
docker pull mshin77/textanalysisr.authr
docker run -p 3838:3838 mshin77/textanalysisr.authr
```
## On the Virtual Server
```
cd apps
rm -rf textanalysisr.app
git clone https://github.com/mshin77/textanalysisr.app.git
cd textanalysisr.app
git pull
docker pull mshin77/textanalysisr.authr
cd rstudio_docker
docker run -d --name textanalysisr -p 3838:3838 mshin77/textanalysisr.authr:latest
docker ps
docker stop <DOCKER_CONTAINER>
docker rm <DOCKER_CONTAINER>
docker ps -a
docker images
docker rmi <DOCKER_IMAGE_ID>
docker-compose down && docker-compose up -d
docker-compose restart

# docker logs -f shiny
```
