#!/usr/bin/env bash
# Glitched edges with afterimage trails (glitch0r + Sobel + Baltan)
#
# Chains three frei0r filters: heavy block glitching, then Sobel edge
# detection, which turns the glitched picture into glowing outlines, then
# Baltan, which blends in recent frames so moving edges leave ghost trails.
#
#   frei0r=glitch0r:0.3|0.3|0.6|0.3
#                          frequent, strong block shifts with color damage
#   frei0r=sobel           white edges on black
#   frei0r=baltan          EffecTV "delayed alpha smoothed blit of time":
#                          afterimage trails
#   -r 29.97 -c:v libx264 -pix_fmt yuv420p
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: -vcodec → -c:v; removed the spaces after commas in the chain
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "frei0r=glitch0r:0.3|0.3|0.6|0.3,frei0r=sobel,frei0r=baltan" \
  -r 29.97 \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4
