#!/usr/bin/env bash
# Remove a burned-in logo or timestamp with delogo, at a steady 29.97 fps
#
# Takes 10 s from 0:15 of an old camera AVI, fills 1920×1080, blurs out a
# burned-in logo or date stamp by interpolating its rectangle from the
# surrounding pixels, and converts the odd camera frame rate to a steady
# 29.97 fps with motion interpolation. The patch works best on flat
# backgrounds; on detailed footage it shows as a soft smudge.
#
#   -ss 15 -t 10           use 0:15–0:25 (drop both to process the whole file)
#   scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080
#                          fill 1080p first, so the delogo box is in output
#                          coordinates
#   delogo=x=597:y=490:w=279:h=163
#                          the rectangle to remove (top-left x/y, size).
#                          Find it by grabbing a frame
#                          (stills-and-gifs/extract-frame-jpg.sh) and
#                          measuring, or add :show=1 to draw the box while
#                          adjusting
#   minterpolate=fps=29.97,setpts=N/(29.97*TB) -r 29.97
#                          steady 29.97 fps without changing speed
#   -c:a aac -b:a 192k -c:v libx264 -crf 20 -pix_fmt yuv420p -preset ultrafast
#
# Source:  ffmpeg-utilities/notes/commands2.txt (two versions: a 10 s test
#          and the full file)
# Changed: minterpolate='fps=29.97' → minterpolate=fps=29.97
# Tested:  ffmpeg 9.0.2

ffmpeg -ss 15 -i input.mp4 \
  -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,delogo=x=597:y=490:w=279:h=163,minterpolate=fps=29.97,setpts=N/(29.97*TB)" \
  -r 29.97 -t 10 \
  -c:a aac -b:a 192k \
  -c:v libx264 -crf 20 -pix_fmt yuv420p -preset ultrafast \
  output.mp4
