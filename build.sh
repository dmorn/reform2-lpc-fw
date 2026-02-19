#!/bin/bash

set -e

VERSION=$(git rev-parse --short HEAD)

cd tools/lpcrc
make
cd ../..

for rev in 20_R3 25_R2 30_R1; do
	make -j$(nproc) REFORM_LPC_OPTIONS="-DREFORM_MOTHERBOARD_REV=REFORM_MBREV_$rev -DFW_STRING3=\\\"$VERSION\\\""
	mv bin/firmware.bin bin/firmware-$rev.bin
	make clean
done

cp bin/firmware-30_R1.bin bin/firmware.bin

echo $(tput bold)
echo "Defaulting to 3.0 R-1 as motherboard revision. If you have an older motherboard,"
echo "copy bin/firmware-20_R3.bin or bin/firmware-25_R2.bin over bin/firmware.bin before flashing!"
echo $(tput sgr0)

