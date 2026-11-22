#!/usr/bin/env bash
# "Nervous" 4× slow motion with slowed audio, 4:3 H.264
#
# The shareable version of frei0r-nervous-slowmo-prores.sh: same jitter +
# interpolation effect, with scene-change detection off so cuts blend,
# audio slowed to match, and a 640×480 frame encoded to H.264.
#
#   frei0r=nervous         random frame reordering (needs frei0r)
#   minterpolate=fps=120:scd=none
#                          interpolate to 120 fps, also across cuts
#   setpts=N/(29.97*TB)    play at 29.97 fps (≈ 4× slower)
#   scale=640:480:force_original_aspect_ratio=increase,crop=640:480
#                          fill a 4:3 frame
#   -af "atempo=0.5,atempo=0.5"
#                          audio at 0.25× to match the video
#   -r 29.97
#   -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p
#
# Variants in the source: 1920×1080 frames (fealin, stranger-cut) and
# 60 fps with one atempo=0.5 for a 2× slowdown.
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/videogrep.sh (the grand-out command)
# Changed: -filter_complex → -vf; -filter:a → -af
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "frei0r=nervous,minterpolate=fps=120:scd=none,setpts=N/(29.97*TB),scale=640:480:force_original_aspect_ratio=increase,crop=640:480" \
  -af "atempo=0.5,atempo=0.5" \
  -r 29.97 \
  -c:a aac -b:a 128k \
  -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p \
  output.mp4
