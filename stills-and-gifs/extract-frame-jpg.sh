#!/usr/bin/env bash
# Grab a single frame as a 600×600 JPEG (poster image / thumbnail)
#
# Seeks to 7 seconds and writes exactly one frame, for use as a <video>
# poster or a thumbnail next to the web encodes in conversion/.
#
#   -ss 7                  seek to 0:07 before decoding (fast)
#   -frames:v 1            write one frame and stop
#   -vf scale=600:600      resize to 600×600 (stretches non-square sources)
#   -q:v 2                 JPEG quality (2–31, lower = better)
#
# Source:  ffmpeg-utilities/ogg-mp4-jpg-600.sh (also vector copy.sh,
#          vector copy 2.sh)
# Changed: "-t 1 -f image2" wrote a second's worth of frames (about 30)
#          over the same filename; -frames:v 1 writes exactly one.
#          -s 600x600 → -vf scale=600:600; added -q:v 2.
# Tested:  ffmpeg 9.0.2

ffmpeg -ss 7 -i input.mp4 \
  -frames:v 1 \
  -vf scale=600:600 \
  -q:v 2 \
  output.jpg
