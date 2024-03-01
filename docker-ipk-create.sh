#!/bin/bash

# build everything
rm -rf toGround/*
docker run --user $(id -u):$(id -g) \
-v "$(pwd)":/opssat-doom:rw \
-it \
sepp-ci:latest \
bash -c 'cd /opssat-doom;
./init-repo.sh; \
./build-all-32.sh; \
./ipk-create.sh'