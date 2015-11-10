#!/bin/bash

inputFile=filesImage.csv
badMD5File=badMD5.csv
searchFile=version.txt

if [ $badMD5File -o $searchFile ]
then
	rm $badMD5File $searchFile
fi

while read line; do

	binaryprog=$(echo "$line" | cut -d ',' -f1)
	currmd5=$(md5sum $binaryprog | cut -d ' ' -f1)
	imagemd5=$(echo "$line" | cut -d ',' -f2)

	if [ ! "$currmd5" == "$imagemd5" ]
	then
		badinfo=$(ls -al $binaryprog | awk '// {print $5 "," $6 "," $7}')
		echo "$binaryprog does not match, $currmd5, $badinfo" >> $badmd5file
	else
		echo "$binaryprog matches md5"
	
	fi
 done < $inputfile
