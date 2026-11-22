#!/usr/bin/env bash
# Ogg Theora/Vorbis video (open-format HTML5 fallback)
#
# Encodes an .ogv for the <video> element in browsers that historically
# didn't ship H.264. Today WebM (VP9 or AV1) is the usual open-format
# choice, but Theora still plays in every major browser and is handy for
# matching older sites built around it. Pairs with web-mp4-square-600.sh.
#
#   -c:v libtheora -q:v 5  Theora at quality 5 (scale 0–10, higher = better)
#   -vf scale=600:600      resize to 600×600 (stretches non-square sources)
#   -af loudnorm           EBU R128 loudness normalization
#   -c:a libvorbis -q:a 4  Vorbis VBR quality 4 (about 128 kb/s)
#   -ar 44100              44.1 kHz audio
#
# Source:  ffmpeg-utilities/ogg-mp4-jpg-600.sh (also vector copy.sh,
#          vector copy 2.sh)
# Changed: -codec:v/-codec:a → -c:v/-c:a; -qscale:v/-qscale:a → -q:v/-q:a;
#          -filter:a → -af
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -c:v libtheora -q:v 5 \
  -vf scale=600:600 \
  -af loudnorm \
  -c:a libvorbis -q:a 4 -ar 44100 \
  output.ogv
