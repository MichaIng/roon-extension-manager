#!/bin/bash

docker container inspect roon-extension-manager > /dev/null 2>&1

if [ $? -eq 0 ]; then
    docker start roon-extension-manager
    docker attach roon-extension-manager
else
    docker run --network host --name roon-extension-manager --group-add ${DOCKER_GID} -v rem_data:/home/node/.rem/ -v /var/run/docker.sock:/var/run/docker.sock -e "TZ=${TZ}" --log-driver journald theappgineer/roon-extension-manager:v1.x

    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

EXIT_CODE=$(docker container inspect roon-extension-manager --format='{{.State.ExitCode}}')

if [ $EXIT_CODE -eq 66 ]; then
    docker rm roon-extension-manager
fi
