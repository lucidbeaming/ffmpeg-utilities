#!/usr/bin/env bash
# Sobel edge detection on its own, cropped to 1024×768
#
# The simplest form of the edge effect: frei0r's Sobel operator keeps only
# the outlines (white edges on black), then crop keeps a centered 1024×768
# (4:3) window for projection or LED-wall work. Run it on footage that's
# already been processed (e.g. frei0r-nervous-slowmo-prores.sh output)
# for layered looks.
#
#   frei0r=sobel           white edges on black
#   crop=1024:768          centered 1024×768 (input must be at least that)
#   -r 29.97 -c:v libx264 -pix_fmt yuv420p
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/notes/commands2.txt (originally run on a
#          glitched, nervous-processed clip)
# Changed: -vcodec → -c:v; removed the space after the comma
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "frei0r=sobel,crop=1024:768" \
  -r 29.97 \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4
