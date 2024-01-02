source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi;
rm -rf output && mkdir output;
qemu-arm src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -iwad demos/doom.wad -cdemo demos/m1-fast -statdump toGround/x.txt;
