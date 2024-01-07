#!/bin/sh

# Define the list of demos
demos="zero-e1m1-short zero-e1m1-long zero-e1m1-run-around"
error=0

rm -rf toGround/
mkdir toGround/

# Loop through each demo
for demo in $demos
do
  # Run Chocolate Doom for each demo
  echo -e "\n\n$(date +"%Y-%m-%d %H:%M:%S") Will OPS-SAT-1 run DOOM?\n" >> toGround/doom.log
  timestamp=$(date +"%Y%m%d%H%M%S")
  ./src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -iwad demos/doom.wad -statdump toGround/${demo}-output-${timestamp}.txt -cdemo demos/${demo} >> toGround/doom.log

  # Check the output
  if diff -w toGround/${demo}-output-${timestamp}.txt demos/${demo}.txt; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") OK - demos/${demo}" >> toGround/summary.log
  else
    echo "$(date +"%Y-%m-%d %H:%M:%S") ERROR - demos/${demo}" >> toGround/summary.log
    error=1
  fi
done

cat toGround/summary.log;

# Qapla'
exit $error
