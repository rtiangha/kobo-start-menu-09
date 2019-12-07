#!/bin/sh
cd "${0%/*}"
./wget "$@" --no-check-certificate
return "$?"
