#!/bin/bash
# Script to move all files in a camera directory to a subfolder for its date 
# and add the timestamp onto the image.

# Example file: $DIR/cam01/tmp/006E07957B06_20170330195859.jpg
# EampleMove: $DIR/cam01/20170330/006E07957B06_20170330195859.jpg

echo "Starting preprocessing"

. "${BASH_SOURCE%/*}/config"

#avoid literal string if no files match
shopt -s nullglob

#loop all camera folders
for d in ${DIR}/*/; do
	echo "Scanning files in $d"
	#loop all jpg files in the tmp directory
	for f in ${d}tmp/*.jpg; do
		fileName=${f##*/}
		#echo "Preprocessing $fileName"
		#parse date and time
		dts="${fileName##*_}"

		yr=${dts:0:4}
		mo=${dts:4:2}
		dy=${dts:6:2}
		hr=${dts:8:2}
		mi=${dts:10:2}
		sc=${dts:12:2}

		printf -v dateTime "%s-%s-%s %s:%s:%s" "$yr" "$mo" "$dy" "$hr" "$mi" "$sc" #create date time
		printf -v subDir "${d}%s%s%s" "$yr" "$mo" "$dy" #create directory name

		#create folder and subfolders if yet don't exist
		mkdir -p "$subDir"

		#add the timestamp to the image
		#find font: https://askubuntu.com/questions/673615/imagemagick-convert-command-cannot-use-fonts
		convert "$f" -gravity SouthEast -pointsize 22 -font "Nimbus-Sans-L-Bold" \
			-fill black \
				-annotate +28+30 "$dateTime" \
				-annotate +30+28 "$dateTime" \
				-annotate +32+30 "$dateTime" \
				-annotate +30+32 "$dateTime" \
			-fill white -annotate +30+30 "$dateTime" \
			"$f"

		#make sure the file is accessable
		chmod 777 "$f"

		#and move the file in correct sub folder
		mv "$f" "$subDir"
	done
done

echo "Preprocessing finished"
