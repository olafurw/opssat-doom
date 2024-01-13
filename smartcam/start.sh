#!/bin/sh

# function to show usage
show_usage() {
  echo "Usage: $0 -i <image_filepath> -w <wad_filepath>"
}

# check if the number of arguments is correct
if [ "$#" -ne 4 ]; then
  show_usage
  exit 1
fi

# parsing arguments
while getopts ":i:w:" opt; do
  case $opt in
    i) image_file="$OPTARG"
    ;;
    w) wad_file="$OPTARG"
    ;;
    \?) show_usage
      exit 1
    ;;
  esac
done

# check if both -i and -w arguments were supplied
if [ -z "$image_file" ] || [ -z "$wad_file" ]; then
  show_usage
  exit 1
fi

# check if both files exist
if [ ! -f "$image_file" ] || [ ! -f "$wad_file" ]; then
  echo "Error: One or both files do not exist."
  exit 1
fi

# todo: run the DOOM experiment
# ...

# if successful, print JSON string
echo '{"doom": 1}'

# successful exit
exit 0
