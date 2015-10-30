#!/bin/sh
rm integrity.csv
files="/bin/* /sbin/* /usr/bin/* /usr/sbin/*"
for i in $files; do
	md5=$(md5sum $i | cut -d ' ' -f1)
	echo "$i,$md5" >> binaryver.csv
done
