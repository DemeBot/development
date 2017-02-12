# development
A docker compose script to orchestrate a local launch of DemeBot

### Dependencies:
Before you can run this application you need the following dependencies. 
```bash
git --version # Developed on: git version 2.9.3
docker -v # Developed on: Docker version 1.13.1, build 092cba3
docker-compose -v # Developed on:  docker-compose version 1.11.0, build 6de1806
node -v # Developed on: v7.5.0
npm -v # Developed on: 4.1.2
```
For some direction on setting up these tools refer to [linux setup guide](https://github.com/DemeBot/development/wiki/Setup).

## Getting started
```terminal
git clone https://github.com/DemeBot/development.git && cd development
git submodule update --init
docker-compose -f install.yml up
docker-compose -f watch.yml up
```
*note* A `COM_NAME` environment variable is required when running the serial service.

After a few minutes of startup time, the system elements should be available at:
```
plant service : localhost:8080/plants/
angular client : localhost/
```
To run the application detached, you can run `docker-compose -f watch.yml up -d` and connect to the output by running `docker-compose logs -f`.

### Checking for status recursively
```bash
git status && git submodule foreach git status
```
