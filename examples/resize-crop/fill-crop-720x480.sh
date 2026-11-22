#!/usr/bin/env bash
# Fill a 720×480 (NTSC-sized) frame, silent, small file
#
# Same scale-then-crop "cover" technique as fill-crop-640x480.sh, at the
# 720×480 NTSC raster. The pixels stay square: for true NTSC DV/DVD output
# you'd also set the 10:11 sample aspect ratio (setsar=10/11) or use
# -target ntsc-dvd.
#
#   scale=720:480:force_original_aspect_ratio=increase,crop=720:480
#                          cover 720×480, crop the overflow from the center
#   -an                    drop the audio
#   -c:v libx264 -preset veryslow -crf 24
#                          slowest preset for the smallest file at quality 24
#   -pix_fmt yuv420p       4:2:0 for player compatibility
#
# Source:  ffmpeg-utilities/crop-ntsc.sh
# Changed: -filter_complex → -vf (single-input chain); -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "scale=720:480:force_original_aspect_ratio=increase,crop=720:480" \
  -an \
  -c:v libx264 -preset veryslow -crf 24 -pix_fmt yuv420p \
  output.mov
