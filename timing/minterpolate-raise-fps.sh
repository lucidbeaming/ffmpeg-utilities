#!/usr/bin/env bash
# Raise footage to 120 fps with interpolated frames, at normal speed
#
# Synthesizes in-between frames so 30 fps footage plays back as smooth
# 120 fps motion, the "smooth motion" TV effect. Unlike the slow-motion
# examples there's no setpts, so the clip keeps its original duration.
# Useful as a source for high-frame-rate edits, or for comparing raw
# interpolation quality.
#
#   minterpolate=fps=120   synthesize frames up to 120 fps
#   -an                    no audio
#   -c:v libx264 -pix_fmt yuv420p
#
# To slow it down afterwards, see timing/minterpolate-slowmo-prores.sh.
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: -filter → -vf; minterpolate='fps=120' → minterpolate=fps=120;
#          -vcodec → -c:v
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mov \
  -vf "minterpolate=fps=120" \
  -an \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4
