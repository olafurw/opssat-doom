#!/bin/bash

# default values
STATIC_FLAG=NO
CLEAN_FLAG=NO

# parse arguments
for arg in "$@"
do
  if [[ "$arg" == "static" ]]; then
    STATIC_FLAG=YES
  elif [[ "$arg" == "clean" ]]; then
    CLEAN_FLAG=YES
  fi
done

# change directory to src
pushd src

# clean if requested
if [[ "$CLEAN_FLAG" == "YES" ]]; then
  make clean
fi

# build the project
make STATIC=$STATIC_FLAG

# Return to the original directory
popd

