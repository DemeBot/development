# development
A docker compose script to orchestrate a local launch of DemeBot

### Dependencies:
Before you can run this application you need the following dependencies. 
```bash
git --version # Developed on: git version 2.9.3
docker -v # Developed on: Docker version 1.13.1, build 092cba3
docker-compose -v # Developed on:  docker-compose version 1.11.0, build 6de1806
```
#### Optional:
Running commands in the terminal will be easier if you have these optional dependencies.
```bash
node -v # Developed on: v7.5.0
npm -v # Developed on: 4.1.2
```
For some direction on setting up these tools refer to [linux setup guide](https://github.com/DemeBot/development/wiki/Setup).

## Getting started
```bash
git clone https://github.com/DemeBot/development.git && cd development
git submodule update --init
git submodule foreach git checkout master      # Optional, prevents detached head problems.
docker-compose -f install.docker-compose.yml up [SERVICE]
docker-compose up [SERVICE]
```
### Live reload
*Increases system requirements. Do not run on the Raspberry Pi*
```bash
docker-compose -f watch.docker-compose.yml up [SERVICE]
```
### Environment variables
A `COM_NAME` environment variable is required when running the serial service.
```bash
COM_NAME=/dev/ttyACM0 docker-compose -f watch.docker-compose.yml up [SERVICE]
```

After a few minutes of startup time, the system elements should be available at:
```
plant service : http://localhost:8080/plants/
angular client : http://localhost/
serial-service : ws://localhost:8080/serial/
```
To run the application detached, you can add the `-d` detach flag. ex: `docker-compose -f watch.docker-compose.yml up -d [SERVICE]`.
To see the services output run: `docker-compose logs -f [SERVICE]`.

### Checking for status recursively
```bash
git status && git submodule foreach git status
```
