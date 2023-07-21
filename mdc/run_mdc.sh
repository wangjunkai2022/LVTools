#!/bin/bash
docker pull vergilgao/mdc:latest

#docker pull ghcr.io/vergilgao/mdc:latest
mkdir test
dd if=/dev/zero of="./test/MIFD-046.mp4" bs=250MB count=1
#docker run --rm --name mdc_test -it -v ${PWD}/test:/data -v ${PWD}/config:/config -e UID=$(stat -c %u test) -e GID=$(stat -c %g test) ghcr.io/vergilgao/mdc:latest
#github AVDC

docker run --rm --name mdc_test -it -v ${PWD}/test:/data -v ${PWD}/config:/config -v ${PWD}/videos/media/movie/JAV:/JAV_output -e UID=$(stat -c %u test) -e GID=$(stat -c %g test) ghcr.io/vergilgao/mdc:latest