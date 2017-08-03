#!/bin/bash
# Script to remove processed files who have reached their max age.

echo "Starting cleanup"

. "${BASH_SOURCE%/*}/config"

#avoid literal string if no files match
shopt -s nullglob

#loop all camera folders
for d in ${DIR}/*/; do
	#loop all mkv files in the current directory
	for f in ${d}*.mkv; do
		fileName=${f##*/}
		echo "Checking $fileName"

		datePart=${fileName:0:8}
		#check if we may already process this folder
		if dds=$(date -d "$datePart" +%s); then #file datestamp
			nds=$(date +%s) #now datestamp
			days=$(( (nds - dds)/(60*60*24) ))
			#we only process the files if they are a day old
			if [ $days -gt "$MAXAGE" ]; then
				# delete files and folders older then MAXAGE days
				echo "removing '$f', $days days old"
				rm -f "$f"
			fi
		fi
	done
done

echo "Cleanup finished"
