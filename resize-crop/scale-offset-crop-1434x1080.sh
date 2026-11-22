#!/usr/bin/env bash
# Crop a near-4:3 1434×1080 window from 1080p footage, at 29.97 fps
#
# Scales the source to cover 1728×1080 (16:10), then cuts a 1434×1080
# window (about 4:3) at an explicit x offset. 147 = (1728 − 1434) / 2, so
# this window is centered; change the x value to slide it left or right.
# Useful for framing widescreen footage for 4:3 projection or monitors.
#
#   scale=1728:1080:force_original_aspect_ratio=increase
#                          cover 1728×1080, keeping the aspect ratio
#   crop=1434:1080:147:0   width:height:x:y of the window to keep
#   -r 29.97               output at NTSC 29.97 fps
#   -an                    drop the audio
#   -c:v libx264 -crf 18 -preset ultrafast -pix_fmt yuv420p
#                          fast, high-quality H.264
#
# Also in notes/commands2.txt: this command, verbatim, for single files
# and in a loop.
#
# Source:  ffmpeg-utilities/ntsc.sh
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mov \
  -vf "scale=1728:1080:force_original_aspect_ratio=increase,crop=1434:1080:147:0" \
  -r 29.97 \
  -an \
  -c:v libx264 -crf 18 -preset ultrafast -pix_fmt yuv420p \
  output.mp4
