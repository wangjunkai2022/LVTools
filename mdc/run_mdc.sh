#!/bin/bash
docker pull vergilgao/mdc:latest

#docker pull ghcr.io/vergilgao/mdc:latest
#mkdir test
#dd if=/dev/zero of="./test/MIFD-046.mp4" bs=250MB count=1
#docker run --rm --name mdc_test -it -v ${PWD}/test:/data -v ${PWD}/config:/config -e UID=$(stat -c %u test) -e GID=$(stat -c %g test) ghcr.io/vergilgao/mdc:latest
#github AVDC
rm -rf ~/mdc_config
mkdir -p -m 777 ~/mdc_config
cp $(dirname $0)/mdc.ini ~/mdc_config/
docker run --rm --name mdc_test -it -v ~/videos:/videos -v ~/config:/config -e UID=1000 -e GID=1000 ghcr.io/vergilgao/mdc:latest
