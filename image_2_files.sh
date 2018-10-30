#!/bin/bash


get_abs_filename() {
  # $1 : relative filename
  path="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

find "$1" -maxdepth 1 -name '*.flac' | while read image; do
    printf "\nSpliting '${image##*/}'s...\n\n"

    # Get image file absolute path
    get_abs_filename "$image"; image_path=$path
    # Get cue file absolute path
    get_abs_filename "${image[@]/%flac/cue}"; cue_path=$path

    outdir="${image_path/%.flac}_SPLITTED"
    mkdir -p "$outdir";
    pwd=$(pwd); cd "$outdir"

    shnsplit -O always -f "$cue_path" -t %n-%t -o flac "$image_path"

    cd $pwd
done
