#!/bin/bash

imagefile=binaryver.csv
badfile=badmd5.csv


while read image && read bad <&3;
do
	echo "Image File: $image"
	echo "Bad File: $bad"
done < $imagefile 3<$badfile
