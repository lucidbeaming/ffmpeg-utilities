#!/usr/bin/env bash
# Compare minterpolate's motion-estimation settings side by side
#
# Renders the same 15 s at 3× slow motion (90 fps played at 29.97) with
# eight different minterpolate settings, one file per setting, so you can
# pick the one with the fewest artifacts for your footage.
#
#   default   motion-compensated interpolation with default settings
#   aobmc     mc_mode=aobmc: adaptive overlapped block motion compensation
#             (smoother block edges)
#   bidir     me_mode=bidir: bidirectional motion estimation
#   esa       me=esa: exhaustive search (slowest, most thorough)
#   umh       me=umh: uneven multi-hexagon search (fast, good quality)
#   mbsize    mb_size=4: smaller macroblocks (finer motion, slower)
#   search    search_param=64: larger search range for fast motion
#   vsbmc     vsbmc=1: variable-size block motion compensation
#
#   -ss 5 -t 15            render 0:05–0:20
#   minterpolate=fps=90:…  interpolate to 90 fps with the given setting
#   setpts=N/(29.97*TB) -r 29.97
#                          play at 29.97 fps (≈ 3× slower)
#
# Source:  ffmpeg-utilities/min.sh
# Changed: the eight commands became one loop; the "aombc" label typo →
#          "aobmc"; reads input.mp4 instead of $1
# Tested:  ffmpeg 9.0.2

settings=(
  "default:"
  "aobmc::mi_mode=mci:mc_mode=aobmc"
  "bidir::mi_mode=mci:me_mode=bidir"
  "esa::mi_mode=mci:me=esa"
  "umh::mi_mode=mci:me=umh"
  "mbsize::mi_mode=mci:mb_size=4"
  "search::mi_mode=mci:search_param=64"
  "vsbmc::mi_mode=mci:vsbmc=1"
)

for s in "${settings[@]}"; do
  label="${s%%:*}"
  opts="${s#*:}"
  ffmpeg -nostdin -ss 5 -t 15 -i input.mp4 \
    -vf "minterpolate=fps=90${opts},setpts=N/(29.97*TB)" \
    -r 29.97 \
    -an \
    -c:v libx264 -crf 21 -preset fast -pix_fmt yuv420p \
    "${label}-output.mp4"
done
