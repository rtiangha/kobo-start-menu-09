#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
target=/mnt/onboard/.kobo/kepub/kepub-book.css

$ksmroot/kbmessage.sh "-f $target"
