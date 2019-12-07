ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version
currentFWversion="2.6.0"


if [ -e $versionfilename ]; then
  currentFWversion=$(awk -F"," '{print $3}' $versionfilename)
  model=$(awk -F"," '{print $6}' $versionfilename)
  model=$(echo $model | awk '{print substr($0,34,3)}')
else
  echo "failed_to_find_model_number_or_current_FW_version"
  exit
fi
echo $($helpers/download_FW_update.sh $model $currentFWversion)
