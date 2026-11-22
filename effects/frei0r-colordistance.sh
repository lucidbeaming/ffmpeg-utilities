#!/usr/bin/env bash
# Color-distance map with frei0r colordistance
#
# Replaces each pixel with its distance from one source color (black by
# default): areas close to that color go dark and everything else
# brightens. The result is a grayscale "how different is this from X" map,
# useful as a matte or for a ghostly, solarized look.
#
#   frei0r=colordistance   distance from the default source color; pass a
#                          color to compare against something else, e.g.
#                          frei0r=colordistance:0.2/0.6/0.9 (r/g/b, 0–1)
#   -c:v libx264 -pix_fmt yuv420p
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: -vcodec → -c:v; output path proc/… → output.mp4
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "frei0r=colordistance" \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4
