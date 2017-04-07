read -r -p "COM_NAME?" COM_NAME
echo ""

read -n 1 -r -p "Run mode? Options:[ (B)uild and serve / (S)erve only / Build and (W)atch / build and serve (D)etached / serve (O)nly detached ] " response
echo ""
response=${response,,}    # tolower

# Startup mysql image

docker-compose -f ./compose-files/docker-compose.yml up -d mysql

if [[ "$response" =~ ^(b)$ ]];
# Build and serve
then
    # Update submodules
    docker-compose -f ./compose-files/build.docker-compose.yml up
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up
    docker-compose -f ./compose-files/docker-compose.yml down
elif [[ "$response" =~ ^(s)$ ]];
# Only serve
then
    # Update submodules
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up
    docker-compose -f ./compose-files/docker-compose.yml down
elif [[ "$response" =~ ^(d)$ ]];
# Build and serve detached
then
    echo "INFO: Running dockerized build scripts detached"
    # Update submodules
    docker-compose -f ./compose-files/build.docker-compose.yml up
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up -d
    docker-compose -f ./compose-files/serve.docker-compose.yml logs -f
elif [[ "$response" =~ ^(o)$ ]];
# Only serve detached
then
    echo "INFO: Running dockerized build scripts detached"
    # Update submodules
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/serve.docker-compose.yml up -d
    docker-compose -f ./compose-files/serve.docker-compose.yml logs -f
elif [[ "$response" =~ ^(w)$ ]];
then
    echo "INFO: Running dockerized watch scripts"
    # Update submodules
    COM_NAME=$COM_NAME docker-compose -f ./compose-files/watch.docker-compose.yml up
else
    echo "INFO: Skipping dockerized run scripts"
fi
