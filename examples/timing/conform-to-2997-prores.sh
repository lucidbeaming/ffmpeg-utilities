#!/usr/bin/env bash
# Slow motion by conforming high-frame-rate footage to 29.97 fps (ProRes)
#
# Plays every frame of a high-frame-rate clip at 29.97 fps instead of
# dropping frames, which is how cameras make "true" slow motion: 120 fps
# footage becomes 4× slower, 60 fps becomes 2× slower. No frames are
# invented (compare minterpolate-slowmo-prores.sh). Output is ProRes 422
# for editing.
#
#   setpts=N/(29.97*TB)    restamp frame N to play at N/29.97 seconds
#   -r 29.97               output at 29.97 fps
#   -an                    drop the audio, which would otherwise stay at
#                          normal speed and end long before the video
#   -c:v prores_ks -profile:v 2
#                          ProRes 422 (0 Proxy, 1 LT, 2 422, 3 HQ)
#   -vendor apl0           tag as Apple-encoded, which some NLEs expect
#   -pix_fmt yuv422p10le   10-bit 4:2:2, ProRes's native format
#
# Source:  ffmpeg-utilities/slow-batch.sh
# Changed: added -an (the original kept normal-speed audio against
#          slowed video)
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "setpts=N/(29.97*TB)" \
  -r 29.97 \
  -an \
  -c:v prores_ks -profile:v 2 -vendor apl0 -pix_fmt yuv422p10le \
  output.mov
