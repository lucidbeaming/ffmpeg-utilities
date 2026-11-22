#!/usr/bin/env bash
# 4× interpolated slow motion with matching slowed audio, square 1080×1080
#
# Interpolates video to 4× slow motion and stretches the audio by the same
# amount so they stay in sync, then fills a 1080×1080 square for social
# feeds. Scene-change detection is off, so cuts morph into each other
# instead of jumping, which is the dreamy look these were made for.
#
#   minterpolate=fps=120:scd=none
#                          interpolate to 120 fps; scd=none keeps
#                          interpolating across scene cuts
#   setpts=N/(29.97*TB)    play the frames at 29.97 fps (≈ 4× slower)
#   scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080
#                          fill a square frame
#   -af "atempo=0.5,atempo=0.5"
#                          slow the audio to 0.25×, pitch unchanged (each
#                          atempo stage is limited to 0.5–100, so chain two)
#   -r 29.97               output at 29.97 fps
#   -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p
#
# Variants in the source: 1920×1080 instead of the square crop, and 60 fps
# with a single atempo=0.5 for a 2× slowdown.
#
# Source:  ffmpeg-utilities/videogrep.sh (the dsa/time/emotion/noise commands)
# Changed: added -r 29.97 and -pix_fmt yuv420p (present in some of the
#          source variants, missing in others); -filter:v/-filter:a → -vf/-af
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "minterpolate=fps=120:scd=none,setpts=N/(29.97*TB),scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080" \
  -af "atempo=0.5,atempo=0.5" \
  -r 29.97 \
  -c:a aac -b:a 128k \
  -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p \
  output.mp4
