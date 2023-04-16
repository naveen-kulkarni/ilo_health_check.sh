temperatue_Check() {
array_Threshold=$(cat tt |awk '{print $4}'| sed 's/\/.*//g'|sed 's/C//g'|grep -v '[A-Za-z]'|sed 's/-//g'|sed '/^$/d')
array_Temp=$(cat tt |awk '{print $3}'| sed 's/\/.*//g'|sed 's/C//g'|grep -v '[A-Za-z]'|sed 's/-//g'|sed '/^$/d')

logDir=$PWD/log
alogDir=$PWD/activeLog
ulogDir=$PWD/inactiveLog
dirType=($logDir $alogDir $ulogDir)
for DirType in "${dirType[@]}"
do
        if [ -d $DirType ]
        then
                echo ""
        else
                mkdir -p $DirType
        fi
done
temperatuteLog=$logDir/temperature.log
tempThreshldLog=$logDir/tempThreshold.log


tempOk=$alogDir/tempOk-$NOW.log
tempHigh=$ulogDir/tempHigh-$NOW.log

echo $array_Temp > $temperatuteLog
echo $array_Threshold > $tempThreshldLog

Array1=$tempThreshldLog
Array2=$temperatuteLog
#echo "-------------- Temprature Checking --------------------------"

for tmp in `cat $Array2`; do
  in=false
	((sensor++))
  for thrs in `cat $Array1`; do
	#for b in "${Array1[@]}"; do
	#((sensor++))
    if [ "$tmp" -lt "$thrs" ]; then
      echo "$tmp is Normal at Sensor ==> $sensor" >>$tempOk 
     in=true
     break
	#else
	# echo "$tmp is not Normal"
    fi
  done
  $in || echo "$tmp is not Normal at  Sensor ==> $sensor" >>$tempHigh
done
echo "----------------- Affected sensors --------------------"
if [ -f $tempHigh ]
then
        if [ -s $tempHigh ]
        then
                cat $tempHigh
        else
                echo "Tep is under threshold"
        fi
else
        echo "File not found"
fi


}
temperatue_Check
