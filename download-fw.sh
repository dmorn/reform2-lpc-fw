#!/bin/bash

programname=$0
fwver=$1

function usage {
        echo "usage: $programname 30_R1  # (if you have motherboard version 3.0 or newer)"
        echo "usage: $programname 25_R2  # (if you have motherboard version 2.5)"
        echo "       $programname 20_R3  # (if you have motherboard version 2.0)"
        echo ""
        exit 1
}

if [ "$fwver" != "30_R1" ] && [ "$fwver" != "25_R2" ] && [ "$fwver" != "20_R3" ]; then
        usage
fi

mkdir -p bin
wget -O bin/firmware.bin "https://source.mnt.re/reform/reform/-/jobs/artifacts/master/raw/reform2-lpc-fw/firmware-$fwver.bin?job=build"

