
affiliates="Kobo Fnac RakutenBooks beta bestbuyca livrariacultura Eason WHSmith"

modelnr=$1
currentFWversion=$2


getPaddedFWversion () {
padit () {
x=$1
while [ ${#x} -lt 3 ]; do
  x="0"$x
done
echo $x
}
localVersion=$1
part1=$(padit $(echo $localVersion | awk -F"." '{print $1}'))
part2=$(padit $(echo $localVersion | awk -F"." '{print $2}'))
part3=$(padit $(echo $localVersion | awk -F"." '{print $3}'))
echo "$part1$part2$part3"
}




queryurlpre="http://api.kobobooks.com/1.0/UpgradeCheck/Device/00000000-0000-0000-0000-000000000$modelnr"
queryurlpost="$currentFWversion/N905xxxxxxxxx"

FWversion=0
bestURL=0

for aff in $affiliates
do
  xmlcontent=$(wget -q -O - "$queryurlpre/$aff/$queryurlpost")
  updateurl=$(echo "$xmlcontent" | awk 'match($0,/UpgradeURL.*zip/){print substr($0,RSTART+13,RLENGTH-13)}')
  if [ "$updateurl" != "" ]; then
    thisFWversion=$(echo "$updateurl" | awk 'match($0,/kobo-update-.*.zip/){print substr($0,RSTART+12,RLENGTH-16)}')
    thisFWversion=$(getPaddedFWversion $thisFWversion)
    if [ $thisFWversion -ge $FWversion ]; then
      FWversion=$thisFWversion
      bestURL=$updateurl
    fi
  fi
done

echo "$bestURL"

