#!/usr/bin/env bash
# Extreme 12.5× slow motion with motion interpolation (butterflow replacement)
#
# Reproduces the original butterflow workflow (speed 0.08, i.e. 12.5×
# slower) with ffmpeg alone. butterflow, an OpenCL optical-flow tool, is no
# longer available. For a 30 fps source, interpolate to 30 × 12.5 = 375 fps,
# then play those frames at 30 fps. The higher-quality motion options
# matter at this stretch, because most frames on screen are synthesized.
#
#   minterpolate=fps=375   synthesize frames up to 375 fps
#     :mi_mode=mci         motion-compensated interpolation
#     :mc_mode=aobmc       overlapped blocks, smoother edges
#     :me_mode=bidir       look both forward and back for motion
#     :vsbmc=1             variable-size blocks for finer detail
#   setpts=N/(30*TB)       play every frame at 30 fps → 375/30 = 12.5×
#   -r 30                  output at 30 fps
#   -an                    no audio
#   -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p
#
# For another factor or source rate: fps = source fps ÷ speed.
# Expect long render times: a 10 s clip becomes 125 s of mostly synthesized
# frames.
#
# Also in notes/commands2.txt: another butterflow run (spd=0.08,
# --poly-s 1.8 --poly-n 7 -ff gaussian -r 29.97), tuning its optical-flow
# smoothing. The minterpolate settings here play the same role.
#
# Source:  ffmpeg-utilities/butter.sh (identical to stretch.sh):
#          butterflow -s a=0,b=end,spd=0.08 --poly-s 2 -ff box -l -v
# Changed: rewritten for ffmpeg's minterpolate, since butterflow is no
#          longer available
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -vf "minterpolate=fps=375:mi_mode=mci:mc_mode=aobmc:me_mode=bidir:vsbmc=1,setpts=N/(30*TB)" \
  -r 30 \
  -an \
  -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p \
  output.mp4
