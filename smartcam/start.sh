#!/bin/sh

# the DOOM experiment directory path
exp_dir="/home/exp272/"

# function to write messages with a timestamp to a log file
log() {
  # echo the original message to the console
  echo "$*"

  # prefix each message with the current timestamp and write to the log file
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "${exp_dir}run.log"
}

show_usage() {
  log "Usage: $0 -i <image_file> [other options]"
  exit 1
}


# Initialize image_file to an empty string
image_file=""

# parsing arguments
while getopts ":i:" opt; do
  case $opt in
    i) image_file="$OPTARG"
    ;;
    *) # catch all other options and do nothing
       # optionally, you could log these if needed
       # echo "Ignoring unrecognized option: $OPTARG"
    ;;
  esac
done

# check if -i has been supplied and is not empty
if [ -z "$image_file" ] ; then
  show_usage
fi

# need the full image file path of the image for uderlying scripts
# smart cam image files are written in /home/exp1000/
image_file=$(readlink -f $image_file)

# check if given image file exists
if [ ! -f "$image_file" ]; then
  log "Error: the image file does not exist ${image_file}"
  exit 1
fi

# save the current directory path
sc_dir=$(pwd)

# cd into the DOOM directory and run the experiment
cd "$exp_dir" || { log "Failed to change directory to ${exp_dir}"; exit 1; }
./start_exp272.sh "$image_file" > /dev/null 2>&1

# return to the original directory
cd "$sc_dir" || { log "Failed to return to ${sc_dir}"; exit 1; }

# if successful, print JSON string
echo '{"doom": 1}'

# successful exit
exit 0
