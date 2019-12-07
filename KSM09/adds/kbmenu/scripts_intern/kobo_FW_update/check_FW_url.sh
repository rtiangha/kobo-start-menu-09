ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version

if [ -e $versionfilename ]; then
  currentFWversion=$(awk -F"," '{print $3}' $versionfilename)
  model=$(awk -F"," '{print $6}' $versionfilename)
  model=$(echo $model | awk '{print substr($0,34,3)}')
else
  echo "failed_to_find_model_number_or_current_FW_version"
  exit
fi
echo $($helpers/get_FW_update_url.sh $model $currentFWversion)
