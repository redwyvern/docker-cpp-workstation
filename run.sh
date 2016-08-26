#!/bin/bash -e

# An example script to run Postfix in production. It uses data volumes under the $DATA_ROOT directory.
# By default /srv.

NAME='ubuntu-devenv'

DATA_ROOT='/srv'
SRC_ROOT="${DATA_ROOT}/${NAME}/src"

HOST_NAME=ubuntu-devenv
NETWORK_NAME=dev_nw
SSH_PORT=1234

docker stop "${NAME}" 2>/dev/null && sleep 1
docker rm "${NAME}" 2>/dev/null && sleep 1
docker run --detach=true --name "${NAME}" --hostname "${HOST_NAME}" \
        --network=${NETWORK_NAME} \
        --volume "${SRC_ROOT}:/home/nickw/src" \
        -p $SSH_PORT:22 \
        redwyvern/ubuntu-devenv && \
    scp -P $SSH_PORT ~/.ssh/id_rsa localhost:~/.ssh    
