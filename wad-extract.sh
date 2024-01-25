# Remove old files
rm -rf extract/;

# Extract the data from the wad
mkdir extract;
pushd extract;
../deutex/src/deutex -doom ../demos/ -xtract;
popd;