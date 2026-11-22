#!/usr/bin/env bash
# Center a PNG logo or watermark on a square 720×720 video
#
# Crops the video to a 720×720 square, then composites a PNG (with
# transparency) dead center. Run it once per logo color to make light and
# dark versions, as the original did with white and black logos.
#
#   [0:v]scale=…:force_original_aspect_ratio=increase,crop=720:720[bg]
#                          fill the square from the first input (the video)
#   [bg][1:v]overlay=(W-w)/2:(H-h)/2
#                          put the second input (the PNG) on top, centered;
#                          W/H = video size, w/h = PNG size
#   -c:a copy              keep the audio untouched
#   -c:v libx264 -preset slow -crf 17 -pix_fmt yuv420p
#                          high-quality H.264
#   -movflags +faststart   web playback starts sooner
#
# Also in notes/commands2.txt: the minimal form with no resize, just
# -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -c:a copy.
#
# Source:  ffmpeg-utilities/overlay.sh (identical to png-overlay.sh)
# Changed: explicit [0:v]/[1:v] stream labels; W/H shorthand for main_w/
#          main_h; -acodec/-vcodec → -c:a/-c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 -i overlay.png \
  -filter_complex "[0:v]scale=720:720:force_original_aspect_ratio=increase,crop=720:720[bg];[bg][1:v]overlay=(W-w)/2:(H-h)/2" \
  -c:a copy \
  -c:v libx264 -preset slow -crf 17 -pix_fmt yuv420p \
  -movflags +faststart \
  output.mp4
