#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
  . $ksmroot/onstart/exp_block

options="-showresourcefiles=png"
$ksmroot/kobomenu $options -qws
