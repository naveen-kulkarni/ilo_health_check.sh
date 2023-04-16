alogDir=$PWD/activeLog
ulogDir=$PWD/inactiveLog
dirType=($alogDir $ulogDir)
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
faulty_fan=$logDir/faultyFan-$NOW.log

fansCheck() {
#echo "-------------- Fans Checking --------------------------"
 #hpasmcli -s "show fans" |sed '/^$/d'|awk '{
 cat ff | sed '/^$/d'|awk '{
if (NR!=1 && NR!=2) 
if ($3 == "Yes" && $6 == "Yes" && $8 == "Yes" )
	#print "Fan_Num --->Present ---> Redundant --->Hot-Plugabble"
	print ("Fan_Num =="  $1 " "  "Present =="   $3 " "  "Redundant =="  $6 " " "Hot-Plugabble ==" $8 " " ,"---->","Healthy") > "/root/naveen/final/activeLog/healthy_fan.log"
else
	print ( "Fan_Num =="  $1 " "  "Present =="   $3 " "  "Redundant =="  $6 " " "Hot-Plugabble ==" $8 " " ,"---->","Faulty" ) > "/root/naveen/final/inactiveLog/faulty_fan.log"
	#print $0,"=>","Faulty";
}'
faultyFan=/root/naveen/final/inactiveLog/faulty_fan.log
if [ -f $faultyFan ]
then
        if [ -s $faultyFan ]
        then
		echo "----------Faulty Fan----------"
                cat $faultyFan
        else
                echo "No Faulty"
        fi
else
        echo "File not found"
fi

}
fansCheck
