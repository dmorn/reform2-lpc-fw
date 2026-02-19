# MNT Reform LPC Firmware

This is the firmware running on the System Controller of the MNT Reform motherboard, which is an NXP LPC11U24 processor.

## Build dependencies

```
sudo apt install make build-essential binutils-arm-none-eabi gcc-arm-none-eabi
```

## Building the firmware

```bash
./build.sh
```

## Flashing the firmware

Execute `./flash.sh` as root on another computer and follow the interactive guidance.

