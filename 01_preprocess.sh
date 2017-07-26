#!/bin/bash
# Script to move all files in a camera directory to a subfolder for its date.
# Example file: $DIR/006E07957B06_20170330195859.jpg
# EampleMove: $DIR/20170330/006E07957B06_20170330195859.jpg
# TODO update script to output date to hour subfolder

. /mnt/data/ftp/scripts/config

#avoid literal string if no files match
shopt -s nullglob

#loop all camera folders
for d in ${DIR}/*/; do
	search="$d*.jpg" #file search string

	#loop all files in the current directory
	for f in $search; do
		datetime=$(echo "$f"|sed 's/.*_//')
		date=$(echo "$datetime"|cut -c -8)
		dir="${d}${date}"

		# create folder and subfolders if yet don't exist
		mkdir -p "$dir"

		# parse year
		echo "Processing $f file..."
		
		dts=$(echo "$f"|sed 's/.*_//')

		yr=${dts:0:4}
		mo=${dts:4:2}
		dy=${dts:6:2}
		hr=${dts:8:2}
		mi=${dts:10:2}
		sc=${dts:12:2}

		printf -v dt "%s-%s-%s %s:%s:%s" $yr $mo $dy $hr $mi $sc

		#find font: https://askubuntu.com/questions/673615/imagemagick-convert-command-cannot-use-fonts
		convert "$f" -gravity SouthEast -pointsize 22 -font "Liberation-Sans" \
			-stroke "#000C" -strokewidth 2 -annotate +30+30  "$dt" \
			-stroke  none   -fill white    -annotate +30+30  "$dt" \
			"$f" 

		# and move files in correct sub folders
		mv "$f" "$dir"
	done
done
