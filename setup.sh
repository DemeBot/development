if [ -f ./setup.env ];
then
    echo "setup template file exists"
fi

if [ -f ./.secret.setup.env ];
then
    first_run=false
else
    first_run=true
    chmod -R +x ./scripts/
    chmod +x ./run.sh
    # Run dotenv setup script in current directory.
    ./scripts/setup-env.sh
fi

# initialize and update any submodules
git submodule update --init

# If first run, subodules will be in detached head state.
# Resolve by forcing all submoudules to checkout the master branch.
if [[ $first_run = true ]];
then
    git submodule foreach git checkout master
    echo "INFO: Detected a first run. Submodules are all checked out in their master branch."
fi

# --------------------------------------------------------
read -n 1 -r -p "Update submodules? [(Y)es/(N)o] " response
echo ""
response=${response,,}    # tolower
if [[ "$response" =~ ^(y)$ ]];
then
    echo "INFO: updating submodules"
    # Update submodules
    git submodule foreach git pull
else
    echo "INFO: Skipping submodule update"
fi

# --------------------------------------------------------
read -n 1 -r -p "Fetch docker images? [(Y)es/(N)o] " response
echo ""
response=${response,,}    # tolower
if [[ "$response" =~ ^(y)$ ]];
then
    echo "INFO: fetching docker images"
    ./scripts/setup-docker.sh
else
    echo "INFO: Skipping docker fetch"
fi

# --------------------------------------------------------
read -n 1 -r -p "Check submodules for mising dotenv files? [(Y)es/(N)o] " response
echo ""
response=${response,,}    # tolower
if [[ "$response" =~ ^(y)$ ]];
then
    echo "INFO: running dotenv setup script in submodules"
    git submodule foreach 'bash ./../scripts/setup-env.sh'
else
    echo "INFO: Skipping submodule dotenv setup"
fi

# --------------------------------------------------------
read -n 1 -r -p "Run install scripts? [(Y)es/(N)o] " response
echo ""
response=${response,,}    # tolower
if [[ "$response" =~ ^(y)$ ]];
then
    echo "INFO: Running dockerized install scripts"
    # Update submodules
    docker-compose -f ./compose-files/install.docker-compose.yml up
else
    echo "INFO: Skipping dockerized install scripts"
fi

# --------------------------------------------------------
read -n 1 -r -p "Run migration scripts? [(U)p/(D)own/(N)o] " response
echo ""
response=${response,,}    # tolower
if [[ "$response" =~ ^(u)$ ]];
then
    echo "INFO: Running migration up"
    # Update submodules
    docker-compose -f ./compose-files/docker-compose.yml up -d mysql
    echo "waiting 20 seconds for mysql to boot up"
    sleep 20
    docker-compose -f ./compose-files/migration.docker-compose.yml up mysql-up
elif [[ "$response" =~ ^(d)$ ]];
then
    echo "INFO: Running migration down"
    # Update submodules
    docker-compose -f ./compose-files/migration.docker-compose.yml up mysql-down
else
    echo "INFO: Skipping dockerized install scripts"
fi

# --------------------------------------------------------
read -n 1 -r -p "Run launch script? [(Y)es/(N)o] " response
echo ""
response=${response,,}    # tolower
if [[ "$response" =~ ^(y)$ ]];
then
    echo "INFO: Running main launch script"
    ./run.sh
else
    echo "INFO: Not running main launch script"
fi


