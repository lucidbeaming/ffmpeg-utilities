#!/usr/bin/env bash
# Edge-detected, warped glitch stack (stutter + blend + Sobel + invert)
#
# The final stage of a chain built up one filter at a time. Each stage
# feeds the next:
#
#   tmix=frames=2:weights="1 1"
#                          average each frame with the previous one (ghosting)
#   shuffleframes=0 1 0 2 … 0 29
#                          snap back to an anchor frame between frames
#                          (see shuffleframes-stutter.sh)
#   frei0r=distort0r:0.02|0.000001
#                          sine-wave warp; amplitude|frequency (needs frei0r)
#   tblend=all_mode=grainextract
#                          blend each frame with the previous one, keeping
#                          only what changed (motion outlines)
#   unsharp=9:9:1.5:9:9:1.5
#                          strong 9×9 sharpening of luma and chroma
#   frei0r=sobel           Sobel edge detection (white edges on black)
#   frei0r=invert0r        invert, giving dark lines on white, like a sketch
#
#   -framerate 29.97 -i frames/f%05d.jpg
#   scale=…,crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200,format=gbrp
#                          fill 1280×720, crop 200 px below center, planar RGB
#   -an -c:v libx264 -preset ultrafast -crf 40 -pix_fmt yuv420p
#                          quick draft encode (use -crf 18 for a final render)
#
# Drop stages from the front of the chain to see each one's contribution;
# the source script stepped through them in that order.
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/faces-ffmpeg.sh (the final order.mp4 command)
# Changed: -r → -framerate for the image input; -filter_complex → -vf;
#          -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -framerate 29.97 -i frames/f%05d.jpg \
  -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720:(in_w-out_w)/2:(in_h-out_h)/2+200,format=gbrp,tmix=frames=2:weights='1 1',shuffleframes=0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 27 0 28 0 29,frei0r=distort0r:0.02|0.000001,tblend=all_mode=grainextract,unsharp=9:9:1.5:9:9:1.5,frei0r=sobel,frei0r=invert0r" \
  -an \
  -c:v libx264 -preset ultrafast -crf 40 -pix_fmt yuv420p \
  output.mp4
