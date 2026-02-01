# TextAnalysisR Docker Image

Pre-built Docker image for [TextAnalysisR](https://mshin77.github.io/TextAnalysisR) with Python integration (spaCy, BERTopic, sentence-transformers) ready to use.

## On the Local Server

```bash
docker build -t mshin77/textanalysisr.authr .
docker push mshin77/textanalysisr.authr:latest
docker pull mshin77/textanalysisr.authr
docker run -p 3838:3838 mshin77/textanalysisr.authr

# docker build --no-cache -t textanalysisr . 
```

## On the Virtual Server

```bash
cd apps
rm -rf textanalysisr.app
git clone https://github.com/mshin77/textanalysisr.app.git
cd textanalysisr.app
git pull
docker pull mshin77/textanalysisr.authr
cd rstudio_docker
docker ps
docker stop <DOCKER_CONTAINER>
docker rm <DOCKER_CONTAINER>
docker ps -a
docker images
docker rmi <DOCKER_IMAGE_ID>
docker run -d --name textanalysisr -p 3838:3838 mshin77/textanalysisr.authr:latest
docker-compose down && docker-compose up -d
docker-compose restart

# docker logs -f shiny
```

## Updating Base Images

After extended periods without rebuilding, pull fresh base images before rebuilding to get OS-level security patches.

```bash
# Pull latest base images
docker pull rocker/shiny-verse:4.4.2
docker pull nginx:latest

# Rebuild with no cache to ensure fresh system packages
docker build --no-cache -t mshin77/textanalysisr.authr .
docker push mshin77/textanalysisr.authr:latest

# On the virtual server, pull the updated image and restart
docker pull mshin77/textanalysisr.authr:latest
docker-compose down && docker-compose up -d
```
