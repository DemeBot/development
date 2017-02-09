# development
A docker compose script to orchestrate a local launch of DemeBot

### Dependencies:
Before you can run this application you need the following dependencies. 
```bash
$ git --version
# git version 2.9.3
$ docker -v
# Docker version 1.13.1, build 092cba3
$ docker-compose -v
# docker-compose version 1.11.0, build 6de1806
```

## Getting started
```terminal
git clone git@github.com:DemeBot/development.git && cd development
git submodule foreach npm install
docker-compose up
```

### Checking for updates recursively
```bash
git status && git submodule foreach git status
```
