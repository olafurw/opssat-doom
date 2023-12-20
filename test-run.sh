./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump x.txt -cdemo demos/e1m7-607 2>&1 > /dev/null;
if diff --strip-trailing-cr x.txt demos/e1m7-607.txt; then
    echo "OK - demos/e1m7-607";
    rm x.txt;
    exit 0;
else
    echo "ERROR - demos/e1m7-607";
    rm x.txt;
    exit 1;
fi