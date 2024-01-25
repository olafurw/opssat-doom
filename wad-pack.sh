rm demos/doom-earth.wad;

pushd extract;
../deutex/src/deutex -doom ../demos/ -iwad -make ../demos/doom-earth.wad;
popd;