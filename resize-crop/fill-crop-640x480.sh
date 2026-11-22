#!/usr/bin/env bash
# Fill a 4:3 640×480 frame at 30 fps (scale up, then center-crop)
#
# The ffmpeg equivalent of CSS "object-fit: cover": scale the source until
# it covers 640×480 on both axes, keeping its aspect ratio, then crop the
# overflow from the center. No letterboxing, no distortion; the edges of
# wider sources are cut off instead.
#
#   scale=640:480:force_original_aspect_ratio=increase
#                          scale up just enough to cover 640×480
#   crop=640:480           cut the centered 640×480 region
#   fps=30                 conform to 30 fps (drops or repeats frames)
#   -c:a aac -b:a 128k     AAC audio, 128 kb/s
#   -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p
#                          high-quality H.264 that plays everywhere
#
# Also in notes/commands2.txt: the same cover-and-crop at 1280×720
# (scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720).
#
# Source:  ffmpeg-utilities/batch 2.sh (also the batch loop in videogrep.sh,
#          where a missing comma read "crop=640:480fps=fps=30")
# Changed: fps=fps=30 → fps=30
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "scale=640:480:force_original_aspect_ratio=increase,crop=640:480,fps=30" \
  -c:a aac -b:a 128k \
  -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p \
  output.mp4
