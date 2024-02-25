set -e;

pushd deutex;
./bootstrap;
./configure;
make;
popd;

pushd playpal-image-resample;
./build-32.sh;
popd;

./build-32.sh;