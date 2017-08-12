#!/bin/bash
# Script to generate movie output of images per day. 
# This takes all the jpg in a folder of current date, puts them in a single mkv and then removes them

echo "Starting processing"

. "${BASH_SOURCE%/*}/config"

#avoid literal string if no files match
shopt -s nullglob

#loop all camera folders
for d in ${DIR}/*/; do
	echo "Scanning $d"
	#loop all folders in the current directory
	for subdir in ${d}*/; do
		dirName=$(basename "$subdir")
		datePart=${dirName:0:8}

		#check if we may already process this folder
		if dds=$(date -d "$datePart" +%s); then #file datestamp
			nds=$(date +%s) #now datestamp
			days=$(( (nds - dds)/(60*60*24) ))
			#we only process the files if they are a day old
			if [ $days -ge 1 ]; then
				echo "processing '$dirName'"

				dest="${d}${datePart}.mkv"
				src="${subdir}*.jpg"

				# create movie output
				mpv "mf://$src" --mf-fps=12 --ofps=12 --ovc libx264 --ovcopts=threads=2 -o "$dest"

				#make sure the file is accessable
				chmod 777 "$dest"

				#remove the source files because we no longer want them
				echo "Removing $subdir"
				#uncomment when tested
				#rm -rf "$subdir"
			fi
		fi
	done
done

echo "Processing finished"
