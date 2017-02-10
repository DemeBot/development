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

## Getting started
```terminal
git clone https://github.com/DemeBot/development.git && cd development
git submodule update --init
git submodule foreach git checkout master
git submodule foreach npm install
docker-compose up
```
After a few minutes of startup time, the system elements should be available at:
```
plant service : plant.YOUR_COMPUTER
angular client : ui.YOUR_COMPUTER
```

### Checking for updates recursively
```bash
git status && git submodule foreach git status
```
