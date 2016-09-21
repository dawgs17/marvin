#!/bin/bash
#Author: Marvin
#Purpose: Memory check

# Variable Declaration

TOTAL_RAM=$(free -m | awk '{print $2}'| head -2 | tail -1) #echo $TOTAL_RAM
 
#FRE RAM USAGE
FREE_RAM=$(free -m | awk '{print $4}'| head -3| tail -1) #echo $FREE_RAM
 
#expr $FREE_RAM - $TOTAL_RAM
FREE_PERCENT=$(( 100*FREE_RAM / TOTAL_RAM )) USED_PERCENT=$(( 100-$FREE_PERCENT)) echo "Percentage Used :" $USED_PERCENT echo echo

#GETOPTS

while getopts ":c:w:e:" opt
do 
	case $opt in
	c)
		if [ "$USED_PERCENT" -ge "$OPTARG" ]
		then 
                echo "ALERT!!! Memory usage is on critical level: $USED_PERCENT"
		exit 1
		echo
		echo
		fi	;;

	w) 
		if [ "$USED_PERCENT" -ge $OPTARG ]
                then
                echo "WARNING!!! Memory usage is on warning level: $USED_PERCENT" 
		#exit 2
		echo
		echo
                fi      ;;

	e) 
		echo "Sending report to email address $OPTARG"  
    ./memory_check.sh $1 $2 > output 
		mail -s "Memory_Check" $OPTARG < output
		if [ "$USED_PERCENT" -ge 90 ]
		then
		ps aux --sort=-%mem | awk 'NR<=10{print $0}' > top10mem
		mail -s "TOP 10 PROCESSES - MEMORY USAGE CRITICAL LEVEL" $OPTARG < top10mem
		fi 
		;;


	\?) 
		echo "invalid argument" ;;

	:)
		 echo "-$OPTARG  requires an argument. Please enter the required parameters: c = critical value, w = threshold value, e = email address to send the report" ;; 

	esac
done


# Notify if no options given
if [ $OPTIND -eq 1 ]
then
echo "No options were passed. Please enter the required parameters: c = critical value, w = threshold value, e = email address to send the report"
fi
