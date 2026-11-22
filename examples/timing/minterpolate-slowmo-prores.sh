#!/usr/bin/env bash
# 4× slow motion with motion-interpolated frames (ProRes)
#
# Generates in-between frames with motion estimation to raise ~30 fps
# footage to 120 fps, then plays those frames at 29.97 fps: a smooth 4×
# slowdown from normal footage. Slow to render; motion artifacts (warping
# around fast or crossing objects) are part of the look.
#
#   minterpolate=fps=120   synthesize frames up to 120 fps (default mode is
#                          motion-compensated interpolation, mi_mode=mci)
#   setpts=N/(29.97*TB)    play every frame at 29.97 fps → 120/29.97 ≈ 4×
#   -r 29.97               output at 29.97 fps
#   -an                    no audio (see minterpolate-slowmo-with-audio.sh)
#   -c:v prores -profile:v 2 -vendor apl0 -pix_fmt yuv422p10le
#                          ProRes 422, 10-bit 4:2:2
#
# For a different slowdown, set fps = source fps × factor.
#
# Source:  ffmpeg-utilities/stretch-nerv-prores.sh (the second command)
# Changed: minterpolate='fps=120' → minterpolate=fps=120 (no quotes needed)
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "minterpolate=fps=120,setpts=N/(29.97*TB)" \
  -r 29.97 \
  -an \
  -c:v prores -profile:v 2 -vendor apl0 -pix_fmt yuv422p10le \
  output.mov
