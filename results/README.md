# Results 
Images captured by the onboard camera are automatically processed and integrated into the game as custom background scenes. This is achieved by [updating the game's WAD file](../replace-sky.sh) to include the acquired images prior to running DOOM. The WAD update and game execution occur immediately after each image capture, showcasing near real-time snapshots of Earth within the gameplay environment.

## AI for Color Optimization
The acquired images are optimized [with k-means unsupervised machine learning](../playpal-image-resample/resample.cpp) to fit DOOM's 256-color palette. This maintains the game's iconic aesthetic while incorporating real pictures of Earth taken from space.

## Screen Captures
A gameplay screenshot at a specific frame is written into an image file for each demo file, documenting the unique integration of pictures from space into the game environment.

## Highlights
Here are some cool results downlinked from the spacecraft. The demo file gameplay scenes include pictures of Earth captured by the onboard camera and embedded into the game's environment. Navigate the results folder for more images, stats, and logs.

<div align="center">
  <table>
    <tr>
      <td><img src="./v2.0/20240324114436/run-000001/frame-001920.jpg" /></td>
      <td><img src="./v2.0/20240324114436/run-000002/frame-000780.jpg" /></td>
    </tr>
    <tr>
      <td><img src="./v2.0/20240324114436/run-000003/frame-001911.jpg" /></td>
      <td><img src="./v2.0/20240324114436/run-000009/frame-002320.jpg" /></td>
    </tr>
  </table>
</div>

## Other
A sample DOOM install log file downlinked from the spacecraft can be found [here](./v2.0/20240319183842_78_s_install_exp272_DOOM_sh.log). It showcases the post-install DOOM logo ASCII art.