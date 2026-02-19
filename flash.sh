#!/bin/sh

set -eu

if [ ! -e ./bin/firmware.bin ]; then
	echo "./bin/firmware.bin doesn't exist. you can compile it from source or" >&2
	echo "use ./download-fw.sh to download the latest binary from source.mnt.re." >&2
	exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
	echo "you need to run this as root (for example by using sudo)" >&2
	exit 1
fi

disk="/dev/disk/by-id/usb-NXP_LPC1XXX_IFLASH_ISP-0:0"

get_disk_property() {
	property="$1"
	if [ "$(udevadm --version)" -lt 250 ]; then
		# no udevadm --property before version 250
		udevadm info --query=property "$disk" | sed -ne "s/^$property=//p"
	else
		udevadm info --query=property --property="$property" --value "$disk"
	fi
}

if [ ! -e "$disk" ]; then
	echo 'Make sure that the battery is disconnected.' >&2
	echo 'Connect power to the mainboard via the barrel jack connector.' >&2
	echo 'Set the DIP switch LPCPROG to “ON”.' >&2
	echo 'Press the button LPCRESET.' >&2
	echo 'Connect the USB cable.' >&2
fi

if [ "$(udevadm --version)" -lt 251 ]; then
	echo 'Press the Enter key once you are ready' >&2
	# shellcheck disable=SC2034
	read -r enter
else
	echo 'Waiting for the disk to appear...' >&2
	udevadm wait --settle "$disk"
fi

if [ "$(get_disk_property "ID_MODEL_ID")" != "000b" ]; then
	echo "unexpected model id" >&2
	exit 1
fi
if [ "$(get_disk_property "ID_VENDOR_ID")" != "1fc9" ]; then
	echo "unexpected vendor id" >&2
	exit 1
fi
if [ "$(get_disk_property "ID_MODEL")" != "LPC1XXX_IFLASH" ]; then
	echo "unexpected model" >&2
	exit 1
fi
if [ "$(get_disk_property "ID_VENDOR")" != "NXP" ]; then
	echo "unexpected vendor" >&2
	exit 1
fi

MOUNTPOINT="$(mktemp --tmpdir --directory reform-lpc-fw.XXXXXXXXXX)"
trap 'umount $MOUNTPOINT' EXIT INT TERM
mount "$disk" "$MOUNTPOINT"

dd if=bin/firmware.bin of="$MOUNTPOINT/firmware.bin" conv=nocreat,notrunc
sync
umount "$MOUNTPOINT"
trap - EXIT INT TERM

echo "Firmware successfully flashed." >&2
echo "Unplug the USB-C / Micro—USB cable." >&2

if [ "$(udevadm --version)" -ge 251 ]; then
	udevadm wait --removed "$disk"
fi

echo 'Set the DIP switch LPCPROG to “OFF”.' >&2
echo 'Press the button LPCRESET.' >&2
