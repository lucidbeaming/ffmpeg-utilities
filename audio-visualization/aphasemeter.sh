#!/usr/bin/env bash
# Stereo phase meter video (aphasemeter)
#
# Shows how in-phase the left and right channels are over time: a bar
# toward the right means correlated (mono-compatible) stereo, toward the
# left means out-of-phase content that can cancel out when summed to mono.
# The median phase is drawn as a cyan line.
#
#   aphasemeter=s=1280x720:mpc=cyan[a][pv]
#                          aphasemeter has two outputs: the audio passed
#                          through ([a]) and the meter video ([pv]);
#                          mpc = median phase color
#   [pv]format=yuv420p[v]  4:2:0 for H.264
#   -map "[v]" -map "[a]"  the meter video plus the audio
#
# Source:  ffmpeg-utilities/notes/ffmpeg-filters.txt
# Changed: labeled both outputs. The original chained format= straight
#          onto aphasemeter, which connects its first (audio) output to a
#          video filter and fails.
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.aiff \
  -filter_complex "[0:a]aphasemeter=s=1280x720:mpc=cyan[a][pv];[pv]format=yuv420p[v]" \
  -map "[v]" -map "[a]" \
  output.mp4
