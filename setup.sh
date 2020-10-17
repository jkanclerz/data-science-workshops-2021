#!/usr/bin/env sh

## Cron restart
rc-service crond restart

## variables 
DS_ROOT=`dirname "$0"`

## Ensure venv exists
python3.8 -m venv ${DS_ROOT}/.venv
## Install python dependency
${DS_ROOT}/.venv/bin/pip install -r ${DS_ROOT}/requirements.txt

echo "We are ready to go!!!!