#!/bin/bash

. /mnt/data/ftp/scripts/config

#avoid literal string if no files match
shopt -s nullglob

#loop all camera folders
for d in ${DIR}/*/; do
	search="$d*" # search string

	#loop all files and folders in the current directory
	for sd in $search; do
		if [[ "$sd" == *.jpg ]]; then
			continue
		fi

		dp=$(basename $sd|cut -c -8) #only take the first 8 characters to make sure there is no extension
		dds=$(date -d $dp +%s) #file datestamp
		if [ $? -eq 0 ]; then #check that the folder is a parsable date
			nds=$(date +%s) #now datestamp

			days=$(( ($nds - dds)/(60*60*24) ))
			if [ $days -gt $MAXAGE ]; then
				# delete files and folders older then MAXAGE days
				echo "removing '$sd', $days days old"
				rm -rf "$sd"
			elif [ $days -gt 1 ] && [ -d "$sd" ]; then
				dir=$(dirname $sd)/
				folder=$(basename $sd)
				# archive the folders older then a day
				echo "archiving '$sd'"
				tar -czf "$sd.tar.gz" -C "$dir" "$folder" --remove-files
			fi
		fi
	done
done
