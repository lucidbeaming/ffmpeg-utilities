#!/usr/bin/env bash
# Audio level histogram video (ahistogram)
#
# Draws how often each loudness level occurs, updated over time, with a
# scrolling history below. Quiet, dynamic music spreads wide, and heavily
# compressed masters pile up near the top. A simple way to see dynamic
# range.
#
#   ahistogram             defaults: 1280×720, 25 fps
#   format=yuv420p         4:2:0 for H.264
#   -map "[v]" -map 0:a    the histogram plus the original audio
#
# Source:  ffmpeg-utilities/notes/ffmpeg-filters.txt
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.aiff \
  -filter_complex "[0:a]ahistogram,format=yuv420p[v]" \
  -map "[v]" -map 0:a \
  output.mp4
