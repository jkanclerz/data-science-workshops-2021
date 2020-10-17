#!/usr/bin/env sh

rc-service crond restart

## Install python dependency
pip install -r requirements.txt

echo "We are ready to go!!!!"
