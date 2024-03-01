
#!/usr/bin/env bash

# Creates the ipk file to install this project into the SEPP onboard the OPS-SAT spacecraft.
# There's also an option to create the ipk file for the Engineering Model (EM), i.e. the FlatSat.

# The project directory path.
project_dir=$(pwd)

# The files that will be packaged into the ipk.
bin_doom=${project_dir}/src/bin/opssat-doom
bin_resample=${project_dir}/playpal-image-resample/resample
bin_deutex=${project_dir}/deutex/src/deutex
replace_sky=${project_dir}/replace-sky.sh
wad_extract=${project_dir}/wad-extract.sh
wad_pack=${project_dir}/wad-pack.sh
run32=${project_dir}/run-32.sh
smartcam_config=${project_dir}/smartcam/config.ini
smartcam_labels=${project_dir}/smartcam/labels.txt
smartcam_start=${project_dir}/smartcam/start.sh
#seu_simulator=${project_dir}/simulate_seu.py
#seu_simulator_test=${project_dir}/test_simulate_seu.py

# Create a list of all binary files to check that they are built for arm32.
binaries="$bin_doom $bin_resample $bin_deutex"

# Create a list of all files to check that they exist.
required_files="$binaries $replace_sky $wad_extract $wad_pack $run32 $smartcam_config $smartcam_labels $smartcam_start"

# Check that the required files exist.
for file in $required_files; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    echo "Ensure all necessary components are built or available."
    exit 1
  fi
done

# Check each binary for ARM compilation.
for binary in $binaries; do
  bin_info=$(file "$binary")
  if [ -z "$(echo $bin_info | grep 'ARM')" ]; then
    echo "The binary $binary was not compiled for ARM architecture:"
    file "$binary"
    exit 1
  fi
done

# Extract the package name, version, and architecture from the control file.
PKG_NAME=$(sed -n -e '/^Package/p' ${project_dir}/sepp_package/CONTROL/control | cut -d ' ' -f2)
PKG_VER=$(sed -n -e '/^Version/p' ${project_dir}/sepp_package/CONTROL/control | cut -d ' ' -f2)
PKG_ARCH=$(sed -n -e '/^Architecture/p' ${project_dir}/sepp_package/CONTROL/control | cut -d ' ' -f2)

# The ipk filename will depend on the target environment: EM (flatsat) or FM (spacecraft).
# For the EM, just affix the filename with "em".
IPK_FILENAME=""

# Deployment directory paths.
target_dir=/home/${PKG_NAME}
deploy_dir=${project_dir}/deploy
deploy_exp_dir=${deploy_dir}/${target_dir}
#deploy_exp_lib_dir=${deploy_exp_dir}/lib

# Clean and initialize the deploy folder.
rm -rf ${deploy_dir}
mkdir -p ${deploy_exp_dir}

# The project can be packaged for the spacecraft (no bash command options) or for the EM (use the 'em' option).
# This distinction is only necessary in case there are files that are environment specific to the EM vs the spacecraft.
if [ "$1" == "" ]; then
  IPK_FILENAME=${PKG_NAME}_${PKG_VER}_${PKG_ARCH}.ipk
  echo "Create ${IPK_FILENAME} for the spacecraft"

  # TODO (Optional): Copy into ${deploy_exp_dir} any spacecraft specific files.

elif [ "$1" == "em" ]; then
  # If packaging for the EM then include some files needed for testing.
  IPK_FILENAME=${PKG_NAME}_${PKG_VER}_${PKG_ARCH}_em.ipk
  echo "Create ${IPK_FILENAME} for the EM"

  # Copy into ${deploy_exp_dir} any EM specific files.
  #cp ${seu_simulator_test} ${deploy_exp_dir}/
  cp sample.jpeg ${deploy_exp_dir}/

else
  # If not deploying for spacecraft nor the EM then an invalid parameter was given.
  echo "Error: invalid option"
  rm -rf ${deploy_dir}
  exit 1
fi

# Copy into ${deploy_exp_dir} core project files that are required for both EM and spacecraft deployments.

# The SEU simulator
#cp ${seu_simulator} ${deploy_exp_dir}/

# Loop through each file in the list.
for full_path in $required_files; do
  # Remove the project_dir prefix and leading slash to get the relative path.
  relative_path=${full_path#$project_dir/}
  
  # Determine the destination directory
  dest_dir="${deploy_exp_dir}/$(dirname ${relative_path})"
  
  # Create the destination directory if it doesn't already exist.
  mkdir -p "$dest_dir"
  
  # Copy the file to the destination directory.
  cp "$full_path" "$dest_dir"
done

# The demo files.
cp -r demos ${deploy_exp_dir}/

# The start and stop scripts.
cp start_${PKG_NAME}.sh ${deploy_exp_dir}/
cp stop_${PKG_NAME}.sh ${deploy_exp_dir}/

# Create the toGround directory.
mkdir ${deploy_exp_dir}/toGround

# Create the data tar file.
cd ${deploy_dir}
tar -czvf data.tar.gz home --numeric-owner --group=0 --owner=0

# Create the control tar file.
cd ${project_dir}/sepp_package/CONTROL
tar -czvf ${deploy_dir}/control.tar.gz control postinst postrm preinst prerm --numeric-owner --group=0 --owner=0
cp debian-binary ${deploy_dir}

# Create the ipk file.
cd ${deploy_dir}
ar rv ${IPK_FILENAME} control.tar.gz data.tar.gz debian-binary
echo "Created ${IPK_FILENAME}"
ls -larth ${IPK_FILENAME}

# Cleanup.
echo "Cleaning"

# Delete the tar files.
rm -f ${deploy_dir}/data.tar.gz
rm -f ${deploy_dir}/control.tar.gz
rm -f ${deploy_dir}/debian-binary

# Delete the experiment home directory.
rm -rf ${deploy_dir}/home

# Done with great success.
echo "Qapla'"
