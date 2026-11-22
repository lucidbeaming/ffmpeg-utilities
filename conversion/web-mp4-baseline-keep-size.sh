#!/usr/bin/env bash
# Maximum-compatibility web MP4 at the source's own size
#
# Re-encodes for playback almost anywhere (H.264 Baseline, 4:2:0, AAC,
# faststart) without resizing: for when the frame size is already right
# and only the encoding needs fixing, e.g. iPhone HEVC or ProRes exports
# headed for a web page.
#
#   -vf format=yuv420p     4:2:0 chroma, which every player supports
#   -c:v libx264 -crf 20 -preset veryfast
#   -profile:v baseline -level:v 4.1
#                          Baseline profile; level 4.1 allows up to 1080p.
#                          Level 3.1, used in the source, only allows up
#                          to 720p, so use it for 720p or smaller
#   -c:a aac -b:a 128k
#   -movflags +faststart   playback can start before the download finishes
#
# Variant in the source: scale=720:720 square with -crf 23 and -c:a copy
# (keeps the original audio). See also web-mp4-square-600.sh.
#
# Source:  ffmpeg-utilities/notes/ffmpeg-filters.txt
# Changed: -level 3.1 → -level:v 4.1 so 1080p sources stay within the
#          level's limits
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mov \
  -vf format=yuv420p \
  -c:v libx264 -crf 20 -preset veryfast -profile:v baseline -level:v 4.1 \
  -c:a aac -b:a 128k \
  -movflags +faststart \
  output.mp4
