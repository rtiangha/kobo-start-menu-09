#!/bin/sh

source $ksmroot/onstart/exp_block

export QWS_DISPLAY=Transformed:KoboFB:Rot90

echo $($ksmroot/kbbouncer/kbbouncer $* -qws)
