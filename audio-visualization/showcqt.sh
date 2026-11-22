#!/usr/bin/env bash
# Musical spectrum video with showcqt (constant-Q transform)
#
# showcqt draws the spectrum on a musical scale, with each octave the same
# width (like piano keys), plus a scrolling sonogram underneath. That
# makes notes and chords readable, unlike a linear FFT spectrum.
#
#   showcqt=size=1280x720:text=0
#                          720p; text=0 hides the note-name labels
#                          (which also avoids needing a font)
#   format=yuv420p         4:2:0 for H.264
#   -map "[v]" -map 0:a    the visualizer plus the original audio
#
# Source:  ffmpeg-utilities/notes/ffmpeg-filters.txt
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.aiff \
  -filter_complex "[0:a]showcqt=size=1280x720:text=0,format=yuv420p[v]" \
  -map "[v]" -map 0:a \
  output.mp4
