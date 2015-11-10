#!/bin/bash

systemImage=~/systemImage.csv
files="/bin/* /sbin/* /usr/bin/* /usr/sbin/*"
directories="/bin /sbin /usr/bin /usr/sbin"

echo "System Image Report \t Generated on $(date -u)" > $systemImage
echo "" >> $systemImage
echo "Size of the directories: " >> $systemImage
du -hcs $directories | sed \$d >> $systemImage
echo "" >> $systemImage

for i in $files;
do
	md5=$(md5sum $i | cut -d ' ' -f1)
	info=$(ls -al $i | awk '// {print $5 "," $6 "," $7}')
	echo "$i,$md5,$info" >> $systemImage
done
