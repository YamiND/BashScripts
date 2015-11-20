#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

todaysDate=$(date | cut -d " " -f2-3)
secureLog=/var/log/secure
secureFile=~/secureFile.txt
secureReport=~/secureMatch.txt
getUsedRAM=$(free -m | awk '/Mem/ {print $3 " MB Used"}')
getFreeRAM=$(free -m | awk '/Mem/ {print $4 " MB Free"}')
getHostname=$(hostname)
getUptime=$(uptime)
getTodayUsers=$(last | awk -v todayPattern="$todaysDate" '$0 ~ todayPattern {print $0}')
getFSUsage=$(df -h | head -n 2)

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
echo -e "Report for $getHostname \t Generated on $(date -u)" >> $secureReport
echo "" >> $secureReport

echo -e "\tUptime/CPU Statistics" >> $secureReport
echo "" >> $secureReport
echo "$getUptime" >> $secureReport
echo "" >> $secureReport

echo -e "\tRAM Statistics" >> $secureReport
echo "" >> $secureReport
echo "$getUsedRAM" >> $secureReport
echo "$getFreeRAM" >> $secureReport
echo "" >> $secureReport

echo -e "\tFilesystem Statistics" >> $secureReport
echo "" >> $secureReport
echo "$getFSUsage" >> $secureReport
echo "" >> $secureReport

echo -e "\tPeople who logged in Today" >> $secureReport
echo "" >> $secureReport
echo "$getTodayUsers" >> $secureReport
echo "" >> $secureReport

echo -e "\tAuthentication Logs" >> $secureReport
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
