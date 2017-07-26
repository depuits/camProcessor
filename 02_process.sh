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
		# and move files in correct sub folders
		mv "$f" "$dir"

		# create movie output
		mpv mf://*.jpg --mf-fps=12 --ofps=12 --ovc libx264 --ovcopts=threads=2 -o ../outputfile_12fps.mkv
	done
done
