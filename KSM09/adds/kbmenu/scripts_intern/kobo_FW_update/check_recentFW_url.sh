ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version
currentFWversion="2.6.1"


if [ -e $versionfilename ]; then
  model=$(awk -F"," '{print $6}' $versionfilename)
  model=$(echo $model | awk '{print substr($0,34,3)}')
else
  echo "failed_to_find_model_number"
  exit
fi
echo $($helpers/get_FW_update_url.sh $model $currentFWversion)
