#!/bin/bash

imageFile=~/passwdImage
compareFile=/etc/passwd
tempFile=~/tempFile.txt
badFile=~/badFile.txt
reportFile=~/reportFile.txt
finalReport=~/finalReport.txt

if [ -f "$badFile" -o ! "$reportFile" -o ! "$tempFile" -o ! "$finalReport" ]
then
	rm $badFile
	rm $reportFile
	rm $tempFile
	rm $finalReport
fi

if [ ! -f "$imageFile" -o ! "$compareFile" ]
then
	echo "Either the image file or the file to be compared doesn't exist"
else

	echo "The files exist, comparison will now begin!"
	if [ "$imageFile" = "$compareFile" ]
	then
		echo -e "" > $finalReport       
                echo -e "Report on $compareFile \t Generated on: $(date -u)" >> $finalReport
		echo "Files are the same!" >> $finalReport
	else
		diff $imageFile $compareFile > $tempFile
	
		while read image;
		do
			compareLine=$(echo $image | grep ">" | cut -d ">" -f 2)
			echo "$compareLine" >> $badFile
		done < $tempFile
		sed '/^$/d' $badFile > $reportFile
		echo -e "" > $finalReport	
		echo -e "Report on $compareFile \t Generated on: $(date -u)" >> $finalReport
		echo "Any lines listed below are from the file being compared." >> $finalReport
		echo "You should look at these immediately and indepth if they do not match" >> $finalReport
		echo "" >> $finalReport

		while read report;
		do
			echo -e "Modified line in file: \n $report" >> $finalReport
		done < $reportFile	
	
		rm $badFile $reportFile $tempFile
	fi
cat $finalReport
echo ""
echo "This log is also located at $finalReport"
fi
