#!/usr/bin/env sh

## Cron restart
#rc-service crond restart

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
    lapack        


## variables 
DS_ROOT=`dirname "$0"`

## Ensure venv exists
python3.8 -m venv ${DS_ROOT}/.venv
## Install python dependency
${DS_ROOT}/.venv/bin/pip install -r ${DS_ROOT}/requirements.txt

echo "We are ready to go!!!!