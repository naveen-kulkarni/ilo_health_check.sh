powerCabChecks() {
#hpasmcli -s " show powersupply" | grep -i 'Power supply'
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
NOW=$(date +"%F")
faulty_Power=$ulogDir/faultyPower-$NOW.log
active_Power=$alogDir/activePower-$NOW.log

redStat=$logDir/redStatPower-$NOW.log
redundant=$alogDir/redundant_Power-$NOW.log
notRedudant=$ulogDir/NotRedun_Power-$NOW.log

condtion=$logDir/ConditionPower-$NOW.log
okCondtion=$alogDir/okConditionPower-$NOW.log
notOkCondition=$ulogDir/notOkCondtion_Power-$NOW.log

powerStatus=$logDir/powerStat-$NOW.log
#active_Power=$logDir/activePower.log
prsnt=$logDir/powerPresent.log
redund=$logDir/powerRedundant.log
condtn=$logDir/Powercondition.log
#hpasmcli -s " show powersupply"|egrep -i Present > $prsnt 
cat pp|egrep -i Present > $prsnt
#hpasmcli -s " show powersupply"|egrep -i Redundant > $redund
cat pp |egrep -i Redundant > $redund
#hpasmcli -s " show powersupply"|egrep -i ok > $condtn
cat pp |egrep -i Condition > $condtn

IFS=$'\n';
#echo "-------------- Power Checking --------------------------"

#pres_lines = 0;
for prt in `cat $prsnt`
do
	((pres_lines++))
	 echo $prt |grep -i yes >>$powerStatus
	if [ $? -eq 0 ]
	then
		echo $prt "Power Cable" $pres_lines >> $active_Power
	else
		echo  $prt "Power Cable" $pres_lines >> $faulty_Power
	#echo $prt "Power Cable" $pres_lines	
	fi
done
#echo "--------------------------------------------"
#red_lines = 0;
for red in `cat $redund`
	do
		((red_lines++))
		#echo  $red  "Power Cable" $red_lines
	echo $red |grep -i yes >> $redStat
	if  [ $? -eq 0 ]
        then
		echo  $red  "Power Cable" $red_lines >>$redundant
	else
		echo  $red  "Power Cable" $red_lines >>$notRedudant
	fi

done

#echo "--------------------------------------------"
#ok_lines = 0;
for cndt in `cat $condtn`
do
        ((ok_lines++))
        #echo $cndt "Power Cable" $ok_lines
	echo $cndt |grep -i ok >>$condtion
	 if  [ $? -eq 0 ]
        then
		echo $cndt "Power Cable" $ok_lines >>$okCondtion
	else
		echo $cndt "Power Cable" $ok_lines >>$notOkCondition
	fi
done

#echo "--------------------------------------------"
echo  "------------Faulty Power-------------------"
if [ -f $notRedudante ]
then
        if [ -s $notRedudant ]
        then
                cat $notRedudant
        else
                echo "No Faulty"
        fi
else
        echo "File not found"
fi

if [ -f $notOkCondition ]
then
        if [ -s $notOkCondition ]
        then
                cat $notOkCondition
        else
                echo "No Faulty"
        fi
else
        echo "File not found"
fi

if [ -f $faulty_Power ]
then
        if [ -s $faulty_Power ]
        then
                cat $faulty_Power
        else
                echo "No Faulty"
        fi
else
        echo "File not found"
fi



}
powerCabChecks
