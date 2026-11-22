#!/usr/bin/env bash
# Convert to a steady 29.97 fps with motion interpolation (no speed change)
#
# For footage with an odd or variable frame rate (screen recordings, web
# video, phone clips): minterpolate synthesizes frames at exactly 29.97 fps
# instead of dropping or duplicating them, so motion stays smooth. Also
# crops a 640×480 window from the center of a larger frame.
#
#   crop=640:480           keep the centered 640×480 (input must be at least
#                          that size)
#   minterpolate=fps=29.97:scd=none
#                          resample to 29.97 fps with interpolated frames
#   setpts=N/(29.97*TB)    evenly restamp frames, keeping the original speed
#   -r 29.97               constant 29.97 fps output
#   -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p
#
# Source:  ffmpeg-utilities/videogrep.sh (the hrdst command)
# Changed: -filter_complex → -vf (single-input chain)
# Tested:  ffmpeg 9.0.2
# Test-fixture: hd

ffmpeg -i input.mp4 \
  -vf "crop=640:480,minterpolate=fps=29.97:scd=none,setpts=N/(29.97*TB)" \
  -r 29.97 \
  -c:a aac -b:a 128k \
  -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p \
  output.mp4
