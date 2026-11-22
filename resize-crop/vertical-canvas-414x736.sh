#!/usr/bin/env bash
# Vertical 8-second loop from landscape footage (Spotify Canvas–style)
#
# Takes 7.9 s starting one minute in, turns landscape footage on its side,
# and scales it into a 9:16 414×736 frame with no audio. Canvas-style loops
# need to be short, vertical and silent.
#
#   -ss 60 -t 7.9          start at 1:00, keep 7.9 s (before -i = fast seek)
#   transpose=2            rotate 90° counter-clockwise (1 = clockwise)
#   scale=414:736          9:16 portrait frame
#   fps=30                 conform to 30 fps
#   -an                    drop the audio
#   -map_metadata 0        keep the source's global metadata (dates, etc.)
#   -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p
#
# Source:  ffmpeg-utilities/batch.sh
# Changed: removed -metadata:s:v rotate="90". Current ffmpeg no longer
#          sets rotation through the "rotate" tag (use -display_rotation
#          as an input option for that), and it already auto-rotates
#          sources that carry a rotation flag, so transpose alone yields
#          an upright frame. fps=fps=30 → fps=30.
# Tested:  ffmpeg 9.0.2

ffmpeg -ss 60 -t 7.9 -i input.mp4 \
  -vf "transpose=2,scale=414:736,fps=30" \
  -an \
  -map_metadata 0 \
  -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p \
  output.mp4
