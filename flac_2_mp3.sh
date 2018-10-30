#!/bin/bash

outdir="$1/${1##*/}_MP3"

if test -d "$outdir"; then
    read -t 3 -n 1 -p "The folder MP3 exists: do you want to overwrite it? (y/n)? " answer
    if  [ $answer = "y" ]; then
      rm -rf "$outdir"
    elif [ $answer = "n" ]; then
      exit
    else
      echo "\nNo valid answer, use y/n."
      exit
    fi
fi

mkdir "$outdir"

for entry in "$1"/*.flac; do
  echo $entry
  output_file="$outdir/${entry##*/}" # create the new path
  output_file="${output_file[@]/%flac/mp3}" # remove .flac extension + add .mp3 extension
#  avconv -i "$entry" -c:a libmp3lame -b:a 320k "$output_file" # convert to mp3
  ffmpeg -i "$entry" -ab 320k -map_metadata 0 -id3v2_version 3 "$output_file"
done
