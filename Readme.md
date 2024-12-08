## On the local server
docker build -t mshin77/textanalysisr.authr . \
docker tag  mshin77/textanalysisr.authr  mshin77/textanalysisr.authr \
docker push  mshin77/textanalysisr.authr:latest \
docker pull mshin77/textanalysisr.authr \
docker run -p 3838:3838 mshin77/textanalysisr.authr

## On the virtual server 
cd /root/apps 
# docker stop textanalysisr 
# docker rm textanalysisr
git clone https://github.com/mshin77/textanalysisr.app.git \
cd textanalysisr.app \
docker pull mshin77/textanalysisr.authr \
docker run -d --name textanalysisr -p 3838:3838 mshin77/textanalysisr.authr:latest
