set -e;

./build-deutex.sh;

pushd playpal-image-resample;
./build-32.sh;
popd;

./build-32.sh;