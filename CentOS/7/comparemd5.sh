#!/bin/bash

inputfile=binaryver.csv
badmd5file=badmd5.csv
matchmd5file=matchmd5.txt
searchfile=version.txt

rm $badmd5file $matchmd5file $searchfile

while read line; do

	binaryprog=$(echo "$line" | cut -d ',' -f1)
	currmd5=$(md5sum $binaryprog | cut -d ' ' -f1)
	imagemd5=$(echo "$line" | cut -d ',' -f2)

	if [ "$currmd5" == "$imagemd5" ]; then
		echo "$binaryprog matches md5" >> $matchmd5file
	else
		# Yes this script assumes ls and awk are not screwed with
		# Then again, if you have a miss matching md5 you have reason to worry
		# So if you want reliability, change the script to use an external drive's
		# version of the programs
		badinfo=$(ls -al $binaryprog | awk '// {print $5 "," $6 "," $7}')
		echo "$binaryprog does not match,  $badinfo" >> $badmd5file
	fi
 done < $inputfile
