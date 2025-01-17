#! /bin/bash

# start docker
systemctl start docker

# start a docker name with
docker run --name manekali -itd -v "/docker_kali":/mane kalilinux/kali-rolling 2> /dev/null

# pass to docker container
docker exec -it -w /mane manekali $*