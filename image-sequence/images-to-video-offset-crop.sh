#!/usr/bin/env bash
# Image sequence to video, filled to 1280×720 with a lowered crop
#
# Turns numbered stills (f00001.jpg, f00002.jpg, …) into a 29.97 fps
# video. The crop sits 200 px below center, the framing the effects/
# examples use for portraits, where centering would cut off chins rather
# than foreheads. This is the base the effects/ chains build on.
#
#   -framerate 29.97       the rate to read the stills at
#   -i frames/f%05d.jpg    %05d = 5-digit, zero-padded frame number
#   scale=1280:720:force_original_aspect_ratio=increase
#                          cover 1280×720
#   crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200
#                          center horizontally, 200 px below center
#                          (clamped to stay inside the frame)
#   -c:v libx264 -crf 18 -pix_fmt yuv420p
#
# Source:  ffmpeg-utilities/faces-ffmpeg.sh (the shared input and crop of
#          every command)
# Changed: -r → -framerate; final-quality -crf 18 instead of the source's
#          -preset ultrafast -crf 40 draft settings
# Tested:  ffmpeg 9.0.2

ffmpeg -framerate 29.97 -i frames/f%05d.jpg \
  -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200" \
  -c:v libx264 -crf 18 -pix_fmt yuv420p \
  output.mp4
