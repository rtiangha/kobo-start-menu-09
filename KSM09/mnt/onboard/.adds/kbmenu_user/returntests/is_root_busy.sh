#!/bin/sh

mp="/root/"

if [ $( lsof | grep -c [[:space:]]$mp ) -gt 0 ]; then
message="$mp is busy"
else
message="$mp is not busy"
fi

echo "$message"

