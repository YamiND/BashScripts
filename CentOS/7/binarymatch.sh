#!/bin/sh
rm binaryver.csv
files="/bin/* /sbin/* /usr/bin/* /usr/sbin/*"
for i in $files; do
	md5=$(md5sum $i | cut -d ' ' -f1)
	info=$(ls -al $i | awk '// {print $5 "," $6 "," $7}')
	echo "$i,$md5,$info" >> binaryver.csv
done
