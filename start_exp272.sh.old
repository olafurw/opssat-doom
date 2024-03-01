#!/bin/bash

# Default system library path
OS_LIB_PATH="/lib"

# Spacecraft file system paths
EXP_HOME_PATH="/home/exp272"
EXP_DOOM_BIN_NAME="opssat-doom"
EXP_DOOM_BIN_PATH="${EXP_HOME_PATH}/src/bin/${EXP_DOOM_BIN_NAME}"
EXP_DOOM_EXEC=$EXP_DOOM_BIN_PATH

# If "dev" argument is provided then use Docker file system paths
# TODO: Prepare the dev environment with /lib/ld-linux-armhf.so.3 symnolic link
if [ "$1" = "dev" ]; then
  source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi
  OS_LIB_PATH="/home/user/poky_sdk/tmp/sysroots/beaglebone/lib"
  EXP_HOME_PATH="/home/user/opssat-doom"
  EXP_DOOM_BIN_PATH="${EXP_HOME_PATH}/src/bin/${EXP_DOOM_BIN_NAME}"
  EXP_DOOM_EXEC="qemu-arm ${EXP_DOOM_BIN_PATH}"
fi

# Experiment directory paths
EXP_LIB_PATH="${EXP_HOME_PATH}/lib"
EXP_TOGROUND_PATH="${EXP_HOME_PATH}/toGround"
EXP_DEMOS_PATH="${EXP_HOME_PATH}/demos"

# Define the list of demos
demos_regular="e1m7-607 impfight m1-fast m1-normal m1-simple"
demos_zero="zero-e1m1-short zero-e1m1-run-around zero-e1m1-long"

# Flag if we are using a Doom build with an rng table of all zeros
demos_zero_rng_flag=1
demos="$demos_regular"
if [ "$demos_zero_rng_flag" -eq 1 ]; then
  demos="$demos_zero"
fi

# Simulate SEU rates of 0.01% and 0.1%
#seu_rates="0.0001 0.001"

# Simulate SEU rate of 0.0001%
seu_rates="0.000001"

# Target files to corrupt with the SEU simulations
#seu_target_files="${EXP_LIB_PATH}/libm.so.6 ${EXP_LIB_PATH}/libc.so.6"
#seu_target_files="${EXP_LIB_PATH}/libm.so.6"
#seu_target_files="${EXP_LIB_PATH}/libc.so.6"
seu_target_files="${EXP_DOOM_BIN_PATH}"

# Create the toGround and output folder if it doesn't exist
mkdir -p $EXP_TOGROUND_PATH/
mkdir -p $EXP_HOME_PATH/output

# Create a lib directory and copy into it the system's libc and libm libraries
# Do this so that we can safely corrup those library to simulate SEU induced bit flips
# UPDATE: This experiment is put on hold
#mkdir -p $EXP_LIB_PATH/

# Make a copy the doom executable so that we can restore it after corrupting it
# Check if the file does not already exist in the backup directory from a previous run
mkdir -p $EXP_HOME_PATH/backup
if [ ! -f "$EXP_HOME_PATH/backup/$(basename $EXP_DOOM_BIN_PATH)" ]; then
  cp "$EXP_DOOM_BIN_PATH" "$EXP_HOME_PATH/backup/"
fi

# Simulate SEU rates of 0.01% and 0.1%
#seu_rates="0.0001 0.001"

# Simulate SEU rate of 0.0001%
seu_rates="0.000001"

# Target files to corrupt with the SEU simulations
#seu_target_files="${EXP_LIB_PATH}/libm.so.6 ${EXP_LIB_PATH}/libc.so.6"
#seu_target_files="${EXP_LIB_PATH}/libm.so.6"
#seu_target_files="${EXP_LIB_PATH}/libc.so.6"
seu_target_files="${EXP_DOOM_BIN_PATH}"

# Create the toGround and output folder if it doesn't exist
mkdir -p $EXP_TOGROUND_PATH/
mkdir -p $EXP_HOME_PATH/output

# Create a lib directory and copy into it the system's libc and libm libraries
# Do this so that we can safely corrup those library to simulate SEU induced bit flips
# UPDATE: This experiment is put on hold
#mkdir -p $EXP_LIB_PATH/

# Make a copy the doom executable so that we can restore it after corrupting it
# Check if the file does not already exist in the backup directory from a previous run
mkdir -p $EXP_HOME_PATH/backup
if [ ! -f "$EXP_HOME_PATH/backup/$(basename $EXP_DOOM_BIN_PATH)" ]; then
  cp "$EXP_DOOM_BIN_PATH" "$EXP_HOME_PATH/backup/"
fi

# Sets LD_LIBRARY_PATH for the duration of this wrapper script,, directing it to use libraries from the experiment's lib directory
# This change is only in effect for the duration of the script and any processes that the script launches
# It does not permanently change the environment for other applications or for the system as a whole
if [ -z "$LD_LIBRARY_PATH" ]; then
  # LD_LIBRARY_PATH is empty or not set, set it directly
  LD_LIBRARY_PATH=$EXP_LIB_PATH
else
  # Append to the existing LD_LIBRARY_PATH
  LD_LIBRARY_PATH=$EXP_LIB_PATH:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

# Loop through each file that's a target for SEU bit flips
for seu_target_file in $seu_target_files
do
  # Loop through the SEU rates to simulate
  for seu_rate in $seu_rates
  do
    # Reset the libraries to uncorrupted state
    # UPDATE: This experiment is put on hold
    #rm -f $EXP_LIB_PATH/ld-linux-armhf.so.3
    #rm -f $EXP_LIB_PATH/libm.so.6
    #rm -f $EXP_LIB_PATH/libc.so.6
    #cp $OS_LIB_PATH/ld-linux-armhf.so.3 $EXP_LIB_PATH/
    #cp $OS_LIB_PATH/libm.so.6 $EXP_LIB_PATH/
    #cp $OS_LIB_PATH/libc.so.6 $EXP_LIB_PATH/

    # Remove corrupted Doom and replace with uncorrupted
    rm -f $EXP_DOOM_EXEC
    cp $EXP_HOME_PATH/backup/$EXP_DOOM_BIN_NAME $EXP_HOME_PATH/src/bin/

    # Flip the bits
    python $EXP_HOME_PATH/simulate_seu.py $seu_target_file $seu_rate

    # Loop through each demo
    for demo in $demos
    do
      # Some logging
      echo -e "\n\n$(date +"%Y-%m-%d %H:%M:%S") Will OPS-SAT-1 run DOOM?" >> toGround/doom.log
      echo -e "$(date +"%Y-%m-%d %H:%M:%S") Simulate SEU rate of ${seu_rate} on ${seu_target_file}\n" >> toGround/doom.log

      # The statdump file path
      statdump_filepath=${EXP_TOGROUND_PATH}/${demo}-output-$(basename "$seu_target_file")-seu_${seu_rate}-$(date +"%Y%m%d%H%M%S").txt

      # Will it run Doom?
      ${EXP_DOOM_EXEC} -nosound -nomusic -nosfx -nodraw -iwad ${EXP_DEMOS_PATH}/doom.wad -statdump ${statdump_filepath} -cdemo ${EXP_DEMOS_PATH}/${demo} >> ${EXP_TOGROUND_PATH}/doom.log 2>&1

      # Check the result of the output
      result="N/A"

      # Check if statdump_filepath exists
      if [ -f "${statdump_filepath}" ]; then
        if diff ${statdump_filepath} ${EXP_DEMOS_PATH}/${demo}.txt; then
          result="OK"
        else
          result="ERROR"
          diff ${statdump_filepath} ${EXP_DEMOS_PATH}/${demo}.txt >> ${EXP_TOGROUND_PATH}/doom.log 2>&1
        fi
      fi

      # Define the path to the CSV file
      csv_log_filepath="$EXP_TOGROUND_PATH/summary.csv"

      # Check if the file exists
      if [ ! -f "$csv_log_filepath" ]; then
        # If the file does not exist, create it and write the header
        echo "date,time,result,demo,seu_target,seu_rate" > "$csv_log_filepath"
      fi

      # Log the result
      echo "$(date +"%Y-%m-%d,%H:%M:%S"),${result},${demo},${seu_target_file},${seu_rate}" >> "$csv_log_filepath"
    done
  done
done

# Qapla'
exit 0
