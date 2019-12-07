#!/bin/sh

if [ ! -h "/sbin/poweroff" ]; then
  rm -f "/sbin/poweroff"
  ln -s ../bin/busybox /sbin/poweroff
fi
