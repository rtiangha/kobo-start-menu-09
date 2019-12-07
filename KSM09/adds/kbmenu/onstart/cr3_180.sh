#!/bin/sh


export ROOT=/mnt/onboard/.kobo/vlasovsoft
cd $ROOT
. ./setvars.sh
export QWS_DISPLAY=Transformed:KoboFB:Rot180
# make the temporary directory for Qt
mkdir -p $TMPDIR

# make fifo
mkfifo $VLASOVSOFT_FIFO

$ROOT/cr3/cr3 -qws

rm $VLASOVSOFT_FIFO
