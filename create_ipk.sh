
#!/usr/bin/env bash

# Creates the ipk file to install this project into the SEPP onboard the OPS-SAT spacecraft.
# There's also an option to create the ipk file for the Engineering Model (EM), i.e. the FlatSat.

# The project directory path.
project_dir=$(pwd)

# The files that will be packaged into the ipk.
bin_doom=${project_dir}/src/chocolate-doom

# Check that the required files exist.
if [ ! -f "$bin_doom" ]; then
  echo "missing the DOOM executable"
  echo "you must first build DOOM"
  exit 1
fi

# Check the DOOM executable binary.
bin_doom_info=$(file $bin_doom)
if [[ $bin_doom_info != *"ARM"* ]]; then
  echo "DOOM was not compiled for the spacecraft:"
  file $bin_doom_info
  exit 1
fi

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
deploy_exp_lib_dir=${deploy_exp_dir}/lib


# Clean and initialize the deploy folder.
rm -rf ${deploy_dir}
mkdir -p ${deploy_exp_lib_dir}

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

  # TODO (Optional): Copy into ${deploy_exp_dir} any EM specific files.

else
  # If not deploying for spacecraft nor the EM then an invalid parameter was given.
  echo "Error: invalid option"
  rm -rf ${deploy_dir}
  exit 1
fi

# Copy into ${deploy_exp_lib_dir} the library files.
cp /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libSDL-1.2.so.0 ${deploy_exp_lib_dir}/
cp /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libSDL_mixer-1.2.so.0 ${deploy_exp_lib_dir}/
cp /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libSDL_net-1.2.so.0 ${deploy_exp_lib_dir}/
#cp /home/user/poky_sdk/tmp/sysroots/beaglebone/usr/lib/libpng16.so.16 ${deploy_exp_lib_dir}/

# Copy into ${deploy_exp_dir} core project files that are required for both EM and spacecraft deployments.

# The executable binary.
mkdir ${deploy_exp_dir}/src
cp ${bin_doom} ${deploy_exp_dir}/src

# The demo files.
cp -r demos ${deploy_exp_dir}/

# The start and stop scripts.
cp start_${PKG_NAME}.sh ${deploy_exp_dir}/
cp stop_${PKG_NAME}.sh ${deploy_exp_dir}/


# Replace relative paths in the test script with full paths in the spacecraft payload computer's file system.
sed -i "s|\./src/chocolate-doom|${target_dir}/src/chocolate-doom|g; s|demos/|${target_dir}/demos/|g; s|toGround/|${target_dir}/toGround/|g" ${deploy_exp_dir}/start_${PKG_NAME}.sh

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
