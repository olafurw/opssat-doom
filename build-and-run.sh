echo "===========================================================================";
rm -rf output && mkdir output;
./build-64.sh;
./src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -iwad demos/doom.wad -playdemo demos/m1-fast -statdump toGround/x.txt;