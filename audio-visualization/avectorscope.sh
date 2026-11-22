#!/usr/bin/env bash
# Stereo vectorscope (Lissajous / goniometer) video from an audio file
#
# avectorscope plots left against right channel: mono sound draws a
# vertical line, wide stereo spreads into clouds, and tones trace looping
# Lissajous figures. Rendered as dots over black, with the audio muxed in.
#
#   avectorscope=draw=dot:zoom=2:scale=log:size=1920x1080
#                          dots instead of lines, 2× zoom, logarithmic
#                          scale so quiet sounds stay visible
#   format=yuv422p10le     10-bit 4:2:2 for ProRes
#   -r 30                  output at 30 fps
#   -map "[v]" -map 0:a    the rendered video plus the original audio
#   -c:v prores_ks -profile:v 3
#                          ProRes 422 HQ
#
# Source:  ffmpeg-utilities/vectorscope.sh
# Changed: format=yuv422p → yuv422p10le; -c:v prores → prores_ks
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.aiff \
  -filter_complex "[0:a]avectorscope=draw=dot:zoom=2:scale=log:size=1920x1080,format=yuv422p10le[v]" \
  -r 30 \
  -map "[v]" -map 0:a \
  -c:v prores_ks -profile:v 3 \
  output.mov
