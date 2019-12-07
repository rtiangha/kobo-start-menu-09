#!/bin/sh

if [[ $# -lt 2 ]]; then
  exit
fi

thepath=$1
[ -d "$thepath" ] || exit

shift
filter=
while test $# -gt 0
do
  if [ "$filter" == "" ];then
    filter="-iname"
  else
    filter="$filter -o -iname"
  fi
  filter="$filter '$1'"
  shift
done

command="find $thepath -maxdepth 1 -type f $filter"
availablefiles=$(eval $command)
count=$(echo "$availablefiles" | awk 'END{print FNR}')

#randnum=$(awk -v var="$count" -v seed="$RANDOM" 'BEGIN {srand(seed); print int(var * rand())+1}')
randnum=$(awk -v var="$count" 'BEGIN {srand(); print int(var * rand())+1}')
selectedfile=$(echo -e "$availablefiles" | awk -v var="$randnum" -v RS="" -F"\n" '{print $var}')

echo "$selectedfile"
