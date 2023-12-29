Dockerfile on GitHub: https://github.com/mshin77/textanalysisr.authr   

Repo name: mshin77/textanalysisr.authr \
docker build -t mshin77/textanalysisr.authr . \
docker tag  mshin77/textanalysisr.authr  mshin77/textanalysisr.authr \
docker push  mshin77/textanalysisr.authr:latest \
docker pull mshin77/textanalysisr.authr \
docker run -p 3838:3838 mshin77/textanalysisr.authr