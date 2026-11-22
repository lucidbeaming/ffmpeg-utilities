#!/usr/bin/env bash
# High-quality GIF with a custom palette, in one command
#
# GIFs are limited to 256 colors. palettegen builds the best 256-color
# palette for these exact frames and paletteuse maps the frames onto it,
# which avoids the banding of ffmpeg's default palette. At 0.5 fps this
# makes a slideshow-style GIF: one frame every 2 seconds of a 20 s span.
#
#   -ss 5 -t 20            use 0:05–0:25 of the source
#   fps=0.5                one frame every 2 seconds (raise for motion)
#   split[a][b]            send the frames to two places
#   [a]palettegen[p]       build the palette from one copy
#   [b][p]paletteuse       render the other copy using that palette
#
# Source:  ffmpeg-utilities/short-gif.sh (also vector-gif.sh, vector-gif 2.sh)
# Changed: the original made the palette from the whole clip in a separate
#          pass (palette.png), then rendered 0:05–0:25. Doing both in one
#          filtergraph builds the palette from the frames actually used and
#          leaves no temporary file behind.
# Tested:  ffmpeg 9.0.2
# Test-fixture: long

ffmpeg -ss 5 -t 20 -i input.mp4 \
  -filter_complex "fps=0.5,split[a][b];[a]palettegen[p];[b][p]paletteuse" \
  output.gif
