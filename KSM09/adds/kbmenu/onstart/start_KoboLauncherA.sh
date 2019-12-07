#!/bin/sh
# ==== autostart variant of the KoboLauncher
# disable led flashing
# echo "ch 4" > /sys/devices/platform/pmic_light.1/lit
# echo "cur 0" > /sys/devices/platform/pmic_light.1/lit
# echo "dc 0" > /sys/devices/platform/pmic_light.1/lit

# set variables
export ROOT=/mnt/onboard/.kobo/KoboLauncher
cd $ROOT
. ./setvars.sh

# make the temporary directory for Qt
mkdir -p $TMPDIR

# make fifo
mkfifo $VLASOVSOFT_FIFO

# run launcher
$ROOT/launcher -qws -stylesheet $STYLESHEET

# remove fifo
rm $VLASOVSOFT_FIFO
