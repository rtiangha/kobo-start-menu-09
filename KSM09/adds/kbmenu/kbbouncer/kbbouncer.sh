#!/bin/sh

source $ksmroot/onstart/exp_block
export QWS_DISPLAY=Transformed:KoboFB:Rot180

echo $($ksmroot/kbbouncer/kbbouncer $* -qws)
