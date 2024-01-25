# Both creates a kmeans reduced image but also exports the pixels to a file.
# The pixels are sorted and uniq'd to create a new playpal file for playpal-test to use.
./build.sh && ./kmeans-reduce ../earth.png ../kmeans.bmp > pixels.txt;
cat pixels.txt | sort -n | uniq > ../playpal-test/new_playpal.txt;
rm pixels.txt;