docker run -it --rm --privileged \
        -v /dev/:/dev/ \
        -v "$PWD"/serial-service/:/usr/src/app/ \
        -w /usr/src/app/ \
        arunk3001/node-serialport:4.0.7-alpine \
        sh -c 'npm run serialport-list'