#!/usr/bin/env sh

## Cron restart
#rc-service crond restart

## REPOS
#REPOS
echo "http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/v3.12/main" > /etc/apk/repositories
echo "http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/v3.12/community" >> /etc/apk/repositories
echo "#http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/edge/main" >> /etc/apk/repositories
echo "#http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/edge/community" >> /etc/apk/repositories
echo "#http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/edge/testing" >> /etc/apk/repositories


##system dependency
apk --update add cmake gcc g++ linux-headers libffi-dev openssl-dev \
	openblas openblas-dev \
	automake \
	libgfortran \
	build-base \
	freetype \
	libgcc \
	subversion \
    tar gzip \
	libxml2 \
	libxml2-dev \
	libxslt-dev gfortran \
	libxslt \
    libxslt-dev \
    libgcc \
    musl \
    libgfortran \
	freetype-dev \
    postgresql-dev \
    openblas \
    lapack \
	wget


## Docker dep
apk --update add docker \
	docker-compose \
	tree

rc-update add docker
service docker start


##system dependency
apk --update add python3 \
    python3-dev 

## variables 
DS_ROOT=`dirname "$0"`
MY_IP=`/sbin/ip -4 -o addr show dev eth1| awk '{split($4,a,"/");print a[1]}'`
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

## Ensure venv exists
python3.8 -m venv ${DS_ROOT}/.venv
## Install python dependency
${DS_ROOT}/.venv/bin/pip install -r ${DS_ROOT}/requirements.txt

## activate  venv
source ${DS_ROOT}/.venv/bin/activate


## cp jupyter cfg in place
if [ ! -d "~/.jupyter" ]; then
mkdir -p ~/.jupyter;
fi

cp ${DS_ROOT}/files/jupyter-cfg/jupyter_notebook_config.json ~/.jupyter/jupyter_notebook_config.json
cp ${DS_ROOT}/files/jupyter-cfg/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py


docker-compose -f ${DS_ROOT}/docker-compose.yaml up --no-recreate -d

## fill postgress
docker exec ds-workshop_datascience_1 bash -c "echo 'create database warehouse;' | psql -U datascience"
docker exec ds-workshop_datascience_1 bash -c 'gunzip < /events.sql.gz |  psql -U datascience'

wget -nc https://github.com/SouthbankSoftware/dbkoda-data/raw/master/SampleCollections/dump/SampleCollections/video_movies.bson
wget -nc https://github.com/SouthbankSoftware/dbkoda-data/raw/master/SampleCollections/dump/SampleCollections/video_movieDetails.bson

docker cp video_movies.bson  ds-workshop_mongodb_1:/tmp/video.bson
docker cp video_movieDetails.bson  ds-workshop_mongodb_1:/tmp/details.bson
docker exec ds-workshop_mongodb_1 bash -c "cd /tmp; mongorestore --db datascience --drop --collection movies details.bson"
docker exec ds-workshop_mongodb_1 bash -c "cd /tmp; mongorestore --db datascience --drop --collection films video.bson"

# clear;

python3 -c "import this";

echo "\n\n"
echo "We are ready to go!!!!"
echo "Your ip is: ${MY_IP}"
echo -e "DB explorer available at: ${GREEN}http://${MY_IP}:8080${NC} in your browser"
echo -e "PostgreSQL server available at: ${GREEN}http://${MY_IP}:5432${NC}"
echo -e "MongoDB server available at: ${GREEN}http://${MY_IP}:27017${NC}"
echo -e "To start jupyter visit: ${GREEN}cd ds-workshop${NC}"
echo -e "then activate venv: ${GREEN}source .venv/bin/activate${NC}"
echo -e "and type: ${GREEN}jupyter notebook${NC}"
echo -e "Finallu type: ${GREEN}http://${MY_IP}:8888${NC} in your browser"
echo -e "Happy codding ${GREEN}:)${NC}"