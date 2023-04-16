#echo "-------------- Drive Checking --------------------------"
#bay_Output=$( hpacucli ctrl all show config |grep -i physicaldrive|awk  '{print $5 $6 $NF}'|awk -F ':' '{print $2}'|sed 's/)//g')
#bay_Output=$( cat dd |grep -i physicaldrive|awk  '{print $5 $6 $NF}'|awk -F ':' '{print $2}'|sed 's/)//g')
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
NOW=$(date +"%F")

driveActive=$alogDir/activeDrive-$NOW.log
driveInactive=$ulogDir/inActiveDrive-$NOW.log

#echo $bay_Output > bay
IFS=$'\n ';
for bayNum in `cat dd`
do
val=$(echo $bayNum|egrep -i -o ok)
	if [[ "$val" == "OK" ]]
              then
                       echo "Active ------> $bayNum" >>$driveActive
else
                      echo "Faulty -------> $bayNum" >>$driveInactive
fi
done
if [ -f $driveInactive ]
then
        if [ -s $driveInactive ]
        then
                echo "--------------Faulty Drive-----------"
                cat $driveInactive
        else
                echo "Inactive Drive Not Found..."
        fi
else
        echo "File not found"
fi

