#!/usr/bin/env bash
# Digital block glitches with frei0r glitch0r (ProRes)
#
# glitch0r randomly shifts horizontal blocks of the picture sideways and
# distorts their colors, like a damaged digital signal. The four values
# set how often and how hard it glitches.
#
#   frei0r=glitch0r:0.1|0.2|0.1|0
#                          parameters, in order (each 0–1):
#                          glitch frequency | block height range |
#                          shift intensity | color glitching intensity
#                          (0 color = shifts only, no color damage)
#   -pix_fmt yuv422p10le -c:v prores -profile:v 2
#                          ProRes 422, 10-bit 4:2:2, for editing
#
# Variant in the source: the stronger 0.3|0.3|0.6|0.3 with crop=1024:768
# after it, encoded to H.264.
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: ".1|.2|.1|0" → "0.1|0.2|0.1|0" (same values, clearer)
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "frei0r=glitch0r:0.1|0.2|0.1|0" \
  -pix_fmt yuv422p10le \
  -c:v prores -profile:v 2 \
  output.mov
