#!/usr/bin/env bash
# Remux to MP4 with the moov atom at the front (faststart)
#
# Rewraps a QuickTime/MP4 file without re-encoding and moves the index
# (the moov atom) to the start of the file, so browsers can begin playback
# before the whole file has downloaded. Fast and lossless: only the
# container changes, every audio and video packet is copied as-is.
#
#   -c copy               copy every stream, no re-encode
#   -movflags +faststart  write the moov atom at the start of the file
#
# Also in notes/ffmpeg-filters.txt: the same remux without +faststart, in a
# *.mov loop. Keep +faststart for anything played on the web.
#
# Source:  ffmpeg-utilities/faststart.sh (same command in vector.sh,
#          vector 2.sh, vector 3.sh, vector 4.sh)
# Changed: -c:v copy -c:a copy → -c copy; faststart → +faststart
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mov \
  -c copy \
  -movflags +faststart \
  output.mp4
