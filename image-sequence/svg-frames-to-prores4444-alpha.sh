#!/usr/bin/env bash
# SVG animation frames to ProRes 4444 with a transparent background
#
# For overlays made as numbered SVG frames (for example primitive output,
# see related-tools/, or frames exported from a vector tool): rasterize
# each SVG to PNG keeping transparency, then encode a ProRes 4444 movie
# with an alpha channel that editors can layer over other footage.
#
# Step 1: rasterize. Most ffmpeg builds can't read SVG directly (that
# needs one built --enable-librsvg), so ImageMagick does it:
#   magick -background none      keep the transparent background
#          -density 96           rendering resolution (raise for sharper
#                                frames before scaling up)
#
# Step 2: encode.
#   -framerate 15 -i png/%05d.png
#                          read frames 00001.png, 00002.png, … at 15 fps
#   scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080
#   -r 29.97 -an
#   -c:v prores_ks -profile:v 4
#                          ProRes 4444, the profile that carries alpha
#   -alpha_bits 8          8-bit alpha (the default 16 is rarely needed)
#   -vendor apl0           tag as Apple-encoded for NLE compatibility
#   -pix_fmt yuva444p10le  10-bit 4:4:4 plus alpha
#
# With an ffmpeg built with librsvg, skip step 1 and read the SVGs
# directly: -framerate 15 -i %05d.svg.
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: fixed "prores_ks-profile:v 4" (missing space); added the
#          ImageMagick step for ffmpeg builds without librsvg; -r 15 before
#          -i → -framerate 15
# Tested:  ffmpeg 9.0.2, ImageMagick 7
# Test-setup: for n in $(seq -w 1 10); do printf '<svg xmlns="http://www.w3.org/2000/svg" width="320" height="180"><circle cx="%d" cy="90" r="40" fill="#e33"/></svg>' $((30+10#$n*25)) > 000$n.svg; done; rm -rf frames input.*

shopt -s nullglob
mkdir -p png

for f in *.svg; do
  magick -background none -density 96 "$f" "png/${f%.svg}.png"
done

ffmpeg -framerate 15 -i png/%05d.png \
  -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" \
  -r 29.97 \
  -an \
  -c:v prores_ks -profile:v 4 -alpha_bits 8 -vendor apl0 -pix_fmt yuva444p10le \
  output.mov
