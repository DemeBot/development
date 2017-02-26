read -r -p "COM_NAME?" COM_NAME
echo ""

read -n 1 -r -p "Run mode? [(S)erve/(W)atch/serve (D)etached] " response
echo ""
response=${response,,}    # tolower

# Startup mysql image

docker-compose -f ./compose-files/docker-compose.yml up -d mysql

if [[ "$response" =~ ^(s)$ ]];
then
    echo "INFO: Running dockerized build scripts"
    # Update submodules
    docker-compose -f ./compose-files/build.docker-compose.yml up
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up
    docker-compose -f ./compose-files/docker-compose.yml down
elif [[ "$response" =~ ^(d)$ ]];
then
    echo "INFO: Running dockerized build scripts detached"
    # Update submodules
    docker-compose -f ./compose-files/build.docker-compose.yml up
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up -d
    docker-compose -f ./compose-files/serve.docker-compose.yml logs -f
    docker-compose -f ./compose-files/docker-compose.yml down
elif [[ "$response" =~ ^(w)$ ]];
then
    echo "INFO: Running dockerized watch scripts"
    # Update submodules
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/watch.docker-compose.yml up
else
    echo "INFO: Skipping dockerized run scripts"
fi
