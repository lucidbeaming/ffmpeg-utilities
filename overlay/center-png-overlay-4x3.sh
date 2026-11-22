#!/usr/bin/env bash
# Center a PNG overlay on a 4:3 640×480 video, silent
#
# The 4:3 version of center-png-overlay-square.sh: fill a 640×480 frame,
# composite a PNG mask or graphic in the middle, drop the audio, and
# squeeze the file small with the slowest preset.
#
#   [0:v]scale=…:force_original_aspect_ratio=increase,crop=640:480[bg]
#                          fill 640×480 from the video
#   [bg][1:v]overlay=(W-w)/2:(H-h)/2
#                          composite the PNG, centered
#   -an                    drop the audio
#   -c:v libx264 -preset veryslow -crf 24 -pix_fmt yuv420p
#                          smallest file at quality 24
#
# Source:  ffmpeg-utilities/overlay4-3.sh (originally with large-circle-50.png)
# Changed: explicit stream labels; -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 -i overlay.png \
  -filter_complex "[0:v]scale=640:480:force_original_aspect_ratio=increase,crop=640:480[bg];[bg][1:v]overlay=(W-w)/2:(H-h)/2" \
  -an \
  -c:v libx264 -preset veryslow -crf 24 -pix_fmt yuv420p \
  output.mov
