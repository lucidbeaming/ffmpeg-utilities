#!/usr/bin/env bash
# Rhythmic stutter: flash back to an anchor frame between every frame
#
# shuffleframes reorders frames in fixed-size groups following a map. Here
# each group of 58 output frames alternates between input frame 0 and
# frames 1–29, so the picture keeps snapping back to the same "anchor"
# frame while it moves forward: a strobing, looping stutter.
#
#   -framerate 29.97 -i frames/f%05d.jpg
#   scale=…,crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200
#                          fill 1280×720, crop 200 px below center
#   format=gbrp            planar RGB
#   shuffleframes=0 1 0 2 0 3 … 0 29
#                          output frame i of each group = input frame map[i]
#   -t 10 -an -c:v libx264 -preset ultrafast -crf 40 -pix_fmt yuv420p
#                          quick draft encode (use -crf 18 for a final render)
#
# A shorter map (0 1 0 2 … 0 8) gives a faster cycle.
#
# Source:  ffmpeg-utilities/faces-ffmpeg.sh (the face-order commands)
# Changed: -r → -framerate for the image input; -filter_complex → -vf;
#          -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -framerate 29.97 -i frames/f%05d.jpg \
  -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200,format=gbrp,shuffleframes=0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 27 0 28 0 29" \
  -t 10 \
  -an \
  -c:v libx264 -preset ultrafast -crf 40 -pix_fmt yuv420p \
  output.mp4
