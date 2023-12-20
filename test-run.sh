./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump compare.txt -cdemo demos/e1m7-607 2>&1 > /dev/null;
if diff --strip-trailing-cr compare.txt demos/e1m7-607.txt; then
    echo "OK - demos/e1m7-607";
else
    echo "ERROR - demos/e1m7-607";
    rm compare.txt;
    exit 1;
fi

./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump compare.txt -cdemo demos/impfight 2>&1 > /dev/null;
if diff --strip-trailing-cr compare.txt demos/impfight.txt; then
    echo "OK - demos/impfight";
else
    echo "ERROR - demos/impfight";
    rm compare.txt;
    exit 1;
fi

./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump compare.txt -cdemo demos/m1-fast 2>&1 > /dev/null;
if diff --strip-trailing-cr compare.txt demos/m1-fast.txt; then
    echo "OK - demos/m1-fast";
else
    echo "ERROR - demos/m1-fast";
    rm compare.txt;
    exit 1;
fi

./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump compare.txt -cdemo demos/m1-normal 2>&1 > /dev/null;
if diff --strip-trailing-cr compare.txt demos/m1-normal.txt; then
    echo "OK - demos/m1-normal";
else
    echo "ERROR - demos/m1-normal";
    rm compare.txt;
    exit 1;
fi

./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump compare.txt -cdemo demos/m1-simple 2>&1 > /dev/null;
if diff --strip-trailing-cr compare.txt demos/m1-simple.txt; then
    echo "OK - demos/m1-simple";
else
    echo "ERROR - demos/m1-simple";
    rm compare.txt;
    exit 1;
fi

rm compare.txt;