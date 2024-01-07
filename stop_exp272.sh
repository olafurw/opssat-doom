#!/bin/sh

# The DOOM experiment will stop on its own.
# But kill the game process in case it's hanging.

# Loop through each line of the ps aux output that matches 'opssat-doom'
for pid in $(ps aux | grep -i "opssat-doom" | grep -v "grep" | awk '{print $2}')
do
  echo "Killing process with PID: $pid"
  kill -9 $pid
done

# Qapla'
exit 0
