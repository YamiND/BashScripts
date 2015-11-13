#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

todaysDate=$(date | cut -d " " -f2-3)
secureLog=/var/log/secure
secureFile=~/secureFile.txt
secureReport=~/secureMatch.txt

#########################
# Remove files if exist #
#########################

if [ $secureFile ]
then
	rm $secureFile 
fi

###################################
# Grab all lines from current day #
###################################

for file in $secureLog;
do
	awk -v todayPattern="$todaysDate" '$0 ~ todayPattern {print $0}' $file >> $secureFile
done

#########################################
# Generate report that matches patterns #
#########################################

echo "Subject: Today's Report for $HOSTNAME" > $secureReport

echo "" >> $secureReport
echo -e "Report for $secureLog \t Generated on $(date -u)" >> $secureReport
echo "" >> $secureReport

while read line;
do
	echo $line | cut -d " " -f5- | awk '/Accepted password/ {print $0}' >> $secureReport
	echo $line | cut -d " " -f5- | awk '/Failed password/ {print $0}' >> $secureReport
	echo $line | cut -d " " -f5- | awk '/not met by user/ {print $0}' >> $secureReport

done < $secureFile

#################################
# Email Report to email address #
#################################

sendmail contact-us@lakertech.com < $secureReport
