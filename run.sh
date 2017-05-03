#!/bin/bash

if [ "$1" != "" ]; then
    COM_NAME=$1
    echo "USING DEVICE: $COM_NAME"
else
    read -r -p "COM_NAME (device path)?" COM_NAME
    echo ""
fi

if [ "$2" != "" ]; then
    response=$2
else
    read -n 1 -r -p "Run mode? Options:[ (B)uild and serve / (S)erve only / Build and (W)atch / build and serve (D)etached / serve (O)nly detached ] " response
    echo ""
fi

response=${response,,}    # tolower

# Startup MySQL image

echo "INFO: Booting up MySQL server"
docker-compose -f ./compose-files/docker-compose.yml up -d mysql
echo "INFO: Waiting for MySQL container to boot"

if [[ "$response" =~ ^(b)$ ]];
# Build and serve
then
    echo "INFO: Running build scripts"
    docker-compose -f ./compose-files/build.docker-compose.yml up
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up
    docker-compose -f ./compose-files/docker-compose.yml down
elif [[ "$response" =~ ^(s)$ ]];
# Only serve
then
    echo "INFO: Running serve scripts"
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up
    docker-compose -f ./compose-files/docker-compose.yml down
elif [[ "$response" =~ ^(d)$ ]];
# Build and serve detached
then
    echo "INFO: Running build scripts"
    docker-compose -f ./compose-files/build.docker-compose.yml up
    echo "INFO: Running serve scripts detached"
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up -d
    docker-compose -f ./compose-files/serve.docker-compose.yml logs -f
elif [[ "$response" =~ ^(o)$ ]];
# Only serve detached
then
    echo "INFO: Running serve scripts detached"
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up -d
    docker-compose -f ./compose-files/serve.docker-compose.yml logs -f
elif [[ "$response" =~ ^(w)$ ]];
then
    echo "INFO: Running watch scripts"
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/watch.docker-compose.yml up
else
    echo "INFO: Unknown command input. Skipping dockerized run scripts"
fi

echo "SCRIPT COMPLETE"
