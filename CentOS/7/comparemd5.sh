#!/bin/bash

inputfile=binaryver.csv
badmd5file=badmd5.txt

while read line; do

	binaryprog=$(echo "$line" | cut -d ',' -f1)
	currmd5=$(md5sum $binaryprog | cut -d ' ' -f1)
	imagemd5=$(echo "$line" | cut -d ',' -f2)

	if [ "$currmd5" == "$imagemd5" ]; then
		echo "$binaryprog matches file md5"
	else
		echo "$binaryprog does not match" >> $badmd5file
	fi
 done < $inputfile
