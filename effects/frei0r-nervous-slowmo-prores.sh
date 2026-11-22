#!/usr/bin/env bash
# Jittery "nervous" frame shuffling, stretched into 4× slow motion (ProRes)
#
# frei0r's nervous filter randomly swaps each frame with a recent one,
# making motion twitch and stutter. Interpolating that jittery footage to
# 4× slow motion makes minterpolate morph between out-of-order frames,
# which turns the twitching into smeared, warping movement.
#
#   frei0r=nervous         randomly reorder frames within a short buffer
#                          (needs an ffmpeg built with frei0r, e.g. the
#                          ffmpeg-full Homebrew formula)
#   minterpolate=fps=120   synthesize frames to 120 fps
#   setpts=N/(29.97*TB)    play at 29.97 fps (≈ 4× slower)
#   -r 29.97 -an
#   -c:v prores -profile:v 2 -vendor apl0 -pix_fmt yuv422p10le
#                          ProRes 422, 10-bit 4:2:2
#
# frei0r: if ffmpeg reports "Could not find module", point it at the
# plugin folder. Homebrew on Apple Silicon installs them where ffmpeg
# doesn't look by default:
#   export FREI0R_PATH=/opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/stretch-nerv-prores.sh (the first command)
# Changed: minterpolate='fps=120' → minterpolate=fps=120
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "frei0r=nervous,minterpolate=fps=120,setpts=N/(29.97*TB)" \
  -r 29.97 \
  -an \
  -c:v prores -profile:v 2 -vendor apl0 -pix_fmt yuv422p10le \
  output.mov
