#!/usr/bin/env bash
# Square 600×600 web MP4: H.264 Baseline with loudness-normalized mono audio
#
# A maximum-compatibility MP4 for embedding on web pages: Baseline profile
# at level 3.1 decodes on almost any device, mono AAC at 44.1 kHz keeps the
# audio small, and loudnorm evens out the volume between clips.
#
#   -vf "scale=600:600,format=yuv420p"
#                          resize to exactly 600×600 (this stretches non-square
#                          sources; see resize-crop/ to crop instead) and use
#                          4:2:0 chroma, which every player supports
#   -af loudnorm           EBU R128 loudness normalization (single pass)
#   -c:v libx264 -crf 20   H.264 at constant quality 20 (lower = better)
#   -profile:v baseline -level:v 3.1
#                          widest decoder support, no B-frames
#   -c:a aac -b:a 128k -ac 1 -ar 44100
#                          AAC, 128 kb/s, mono, 44.1 kHz
#   -movflags +faststart   playback can start before the download finishes
#
# Source:  ffmpeg-utilities/ogg-mp4-jpg-600.sh (also vector copy.sh,
#          vector copy 2.sh)
# Changed: -filter:a → -af; -level → -level:v
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "scale=600:600,format=yuv420p" \
  -af loudnorm \
  -c:v libx264 -crf 20 -profile:v baseline -level:v 3.1 \
  -c:a aac -b:a 128k -ac 1 -ar 44100 \
  -movflags +faststart \
  output.mp4
