#!/usr/bin/env bash
# Stretch an image sequence's levels to full black and white
#
# The normalize filter maps the darkest pixels to black and the brightest
# to white over a rolling window of frames, a dynamic auto-levels. With
# independence=1 each color channel is stretched separately, which also
# removes color casts (and can shift colors dramatically on flat footage).
# Use independence=0 to stretch all channels together and keep the hues.
#
#   -framerate 29.97 -i frames/f%05d.jpg
#                          read f00001.jpg, f00002.jpg, … at 29.97 fps
#   scale=1280:720:force_original_aspect_ratio=increase
#   crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200
#                          fill 1280×720, crop centered horizontally and
#                          200 px below center (ffmpeg clamps the window
#                          to stay inside the frame)
#   format=gbrp            planar RGB, so normalize works per color channel
#   normalize=blackpt=black:whitept=white:independence=1
#   -t 10                  stop after 10 seconds
#   -an -c:v libx264 -preset ultrafast -crf 40 -pix_fmt yuv420p
#                          very fast, very rough draft encode for previews
#                          (use -crf 18 for a final render)
#
# Source:  ffmpeg-utilities/faces-ffmpeg.sh (the first two commands)
# Changed: -r 29.97 before -i → -framerate 29.97 (the image2 demuxer's own
#          option); -filter_complex → -vf; -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -framerate 29.97 -i frames/f%05d.jpg \
  -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200,format=gbrp,normalize=blackpt=black:whitept=white:independence=1" \
  -t 10 \
  -an \
  -c:v libx264 -preset ultrafast -crf 40 -pix_fmt yuv420p \
  output.mp4
