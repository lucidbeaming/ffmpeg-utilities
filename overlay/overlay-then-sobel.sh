#!/usr/bin/env bash
# Composite a centered PNG, then edge-detect the whole frame (4:3 1024×768)
#
# Fills a 1024×768 frame, places a PNG in the middle, and then runs Sobel
# edge detection over the composite, so the logo and the footage turn into
# outlines together: a single line-drawing look, rather than a clean logo
# laid over processed video.
#
#   [0:v]scale=1024:768:force_original_aspect_ratio=increase,crop=1024:768[bg]
#                          fill a 4:3 frame
#   [bg][1:v]overlay=(W-w)/2:(H-h)/2
#                          composite the PNG, centered
#   frei0r=sobel           edge-detect the composite
#   -an -c:v libx264 -pix_fmt yuv420p
#
# Swap the order (Sobel on [0:v] first, then overlay) to keep the logo
# clean on top of edge-detected footage.
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/notes/commands2.txt (with lucidwhite.png)
# Changed: explicit stream labels; W/H shorthand; -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 -i overlay.png \
  -filter_complex "[0:v]scale=1024:768:force_original_aspect_ratio=increase,crop=1024:768[bg];[bg][1:v]overlay=(W-w)/2:(H-h)/2,frei0r=sobel" \
  -an \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4
