#!/bin/sh

show_usage() {
  echo "Usage: $0 -i <image_file> [other options]"
  # You can list other recognized options here
  exit 1
}

# Initialize image_file to an empty string
image_file=""

# parsing arguments
while getopts ":i:" opt; do
  case $opt in
    i) image_file="$OPTARG"
    ;;
    *) # Catch all other options and do nothing
       # Optionally, you could log these if needed
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
image_file=/home/exp1000/$image_file

# check if given image file exists
if [ ! -f "$image_file" ]; then
  echo "Error: The image file does not exist."
  exit 1
fi

# Save the current directory path
sc_dir=$(pwd)

# the DOOM experiment directory path
exp_dir="/home/exp272/"

# Check if the directory exists
if [ -d "$exp_dir" ]; then
  # If the directory exists, cd into it and run the experiment
  cd "$exp_dir" || exit 1
  ./start_exp272.sh "$image_file" > /dev/null 2>&1

  # Return to the original directory
  cd "$sc_dir" || exit 1
else
  # If the directory does not exist, print an error message
  echo "DOOM is not installed!"
  exit 1
fi

# if successful, print JSON string
echo '{"doom": 1}'

# successful exit
exit 0
