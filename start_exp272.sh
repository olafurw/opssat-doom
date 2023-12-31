#!/bin/sh

# Define the list of demos
demos="e1m7-607 impfight m1-fast m1-normal m1-simple"

# Simulate SEU rates of 0.01% and 0.1%
seu_rates="0.0001 0.001"

# Target files to corrupt with the SEU simulations
seu_target_files="./lib/libm.so.6 ./lib/libc.so.6"

# Create the toGround folder if it doesn't exist
mkdir -p toGround/

# Create a lib directory and copy into it the system's libc and libm libraries
# Do this so that we can safely corrup those library to simulate SEU induced bit flips
mkdir -p ./lib/

# Sets LD_LIBRARY_PATH for the duration of this wrapper script,, directing it to use libraries from the experiment's lib directory
# This change is only in effect for the duration of the script and any processes that the script launches
# It does not permanently change the environment for other applications or for the system as a whole
export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH

# Loop through each file that's a target for SEU bit flips
for seu_target_file in $seu_target_files
do
  # Loop through the SEU rates to simulate
  for seu_rate in $seu_rates
  do
    # Reset the libraries to uncorrupted state
    rm -f ./lib/libm.so.6
    rm -f ./lib/libc.so.6
    cp /lib/libm.so.6 ./lib/
    cp /lib/libc.so.6 ./lib/

    # Flip the bits
    python ./simulate_seu.py $seu_target_file $seu_rate

    # Loop through each demo
    for demo in $demos
    do
      # Some logging
      echo -e "\n\n$(date +"%Y-%m-%d %H:%M:%S") Will OPS-SAT-1 run DOOM?" >> toGround/doom.log
      echo -e "$(date +"%Y-%m-%d %H:%M:%S") Simulate SEU rate of ${seu_rate} on ${seu_target_file}\n" >> toGround/doom.log

      # The statdump file path
      statdump_filepath=toGround/${demo}-output-$(basename "$seu_target_file")-seu_${seu_rate}-$(date +"%Y%m%d%H%M%S").txt

      # Will it run Doom?
      ./src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -iwad demos/doom.wad -statdump ${statdump_filepath} -cdemo demos/${demo} >> toGround/doom.log 2>&1


      # Check the result of the output
      result="N/A"
      if diff ${statdump_filepath} demos/${demo}.txt; then
        result="OK"
      else
        result="ERROR"
      fi

      # Log the result
      echo "$(date +"%Y-%m-%d %H:%M:%S") ${result} - Demo: demos/${demo} - SEU target: $(basename "$seu_target_file") - SEU rate: ${seu_rate}" >> toGround/summary.log
    done
  done
done

# Qapla'
exit 0
