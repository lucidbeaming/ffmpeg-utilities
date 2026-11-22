#!/usr/bin/env bash
# Subtle glitches in a spinning, jittering feedback loop (glitch0r + Vertigo + Nervous)
#
# Light block glitching, then Vertigo, which blends each frame with a
# zoomed and rotated copy of earlier ones (a swirling video-feedback
# tunnel), then Nervous, which randomly reorders recent frames so the
# swirl twitches.
#
#   frei0r=glitch0r:0.01|0.1|0.4|0.1
#                          rare, small block shifts
#   frei0r=vertigo         EffecTV: alpha blending with zoomed and rotated
#                          images (parameters: phase increment, zoom rate)
#   frei0r=nervous         random frame reordering
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
  -vf "frei0r=glitch0r:0.01|0.1|0.4|0.1,frei0r=vertigo,frei0r=nervous" \
  -r 29.97 \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4
