#!/usr/bin/env bash
# Polar and Lissajous vectorscopes drawn with lines
#
# Two more ways to plot left against right channel, compared with the dot
# vectorscope in avectorscope.sh. Polar mode folds the plot into a
# half-circle fan, like a hardware stereo goniometer. Lissajous XY plots L
# on X and R on Y, so tones trace spirograph-like loops. Drawing with lines
# instead of dots gives continuous, glowing traces.
#
#   avectorscope=size=1280x720:mode=polar:zoom=10:draw=line
#                          polar fan, 10× zoom, connected lines
#   avectorscope=…:mode=lissajous_xy:zoom=3:draw=line
#                          L/R on X/Y axes, 3× zoom
#   format=yuv420p         4:2:0 for H.264
#   -map "[v]" -map 0:a    the scope plus the original audio
#
# Lower zoom suits loud material; raise it for quiet recordings.
#
# Source:  ffmpeg-utilities/notes/ffmpeg-filters.txt
# Changed: the source also ran "ffmpeg -i *.aiff … *.mp4", which doesn't
#          batch: the shell expands the globs into one command line. For
#          batches, see batch/render-visualizer-set.sh.
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.aiff \
  -filter_complex "[0:a]avectorscope=size=1280x720:mode=polar:zoom=10:draw=line,format=yuv420p[v]" \
  -map "[v]" -map 0:a \
  polar-output.mp4

ffmpeg -i input.aiff \
  -filter_complex "[0:a]avectorscope=size=1280x720:mode=lissajous_xy:zoom=3:draw=line,format=yuv420p[v]" \
  -map "[v]" -map 0:a \
  lissajous-output.mp4
