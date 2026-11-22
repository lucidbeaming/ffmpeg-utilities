#!/usr/bin/env bash
# Redraw images as SVGs made of simple shapes, with primitive
#
# primitive (https://github.com/fogleman/primitive) recreates an image by
# adding one shape at a time, each placed to best reduce the difference from
# the original. A few hundred triangles give a recognizable low-poly
# version, saved as a small, scalable SVG. Pair it with ffmpeg by extracting
# frames (stills-and-gifs/extract-frame-jpg.sh, or -vf fps=… to frames/),
# redrawing each one, and reassembling the rendered frames with
# image-sequence/.
#
# Install: go install github.com/fogleman/primitive@latest
#          (needs a recent Go toolchain)
#
#   -i / -o                input image / output file (.svg, .png, .jpg or
#                          .gif, chosen by extension)
#   -m                     shape mode: 0 combo, 1 triangle, 2 rectangle,
#                          3 ellipse, 4 circle, 5 rotated rectangle,
#                          6 Bézier curve, 7 rotated ellipse, 8 polygon
#   -n                     number of shapes (more = more detail, slower)
#
# Source:  ffmpeg-utilities/png-svg.sh
# Changed: name=`echo "${i%.*}"` → "${f%.*}"; mkdir -p for the output
#          folder; nullglob
# Not tested here: primitive is a separate install.

shopt -s nullglob
mkdir -p svg

for f in *.png; do
  primitive -i "$f" -o "svg/${f%.*}.svg" -m 1 -n 150   # 150 triangles
  # primitive -i "$f" -o "svg/${f%.*}.svg" -m 6 -n 300 # 300 Bézier curves
done
