source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi;
qemu-arm src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -runid 3 -iwad demos/doom-earth.wad -cdemo demos/zero-e1m1-long -statdump toGround/x.txt;
