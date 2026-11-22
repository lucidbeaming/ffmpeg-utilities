#!/usr/bin/env bash
# Shuffled difference-blend glitch in interpolated slow motion
#
# Shuffles frames, keeps only the difference between neighbours (glowing
# motion edges on black), stretches those edges to full contrast, then
# interpolates the result into ~3.3× slow motion with audio to match.
#
#   -ss 21                 start 21 s in
#   random=frames=5        output frames in random order within a 5-frame
#                          buffer
#   tblend=all_mode=difference
#                          |frame − previous frame|: static areas go black
#   normalize=blackpt=black:whitept=white:smoothing=0
#                          stretch the faint differences to full range,
#                          recalculated every frame (no smoothing)
#   minterpolate=fps=100:scd=none
#                          interpolate to 100 fps, also across cuts
#   setpts=N/(29.97*TB)    play at 29.97 fps (≈ 3.3× slower)
#   scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080
#   unsharp                default 5×5 sharpen to crisp the edges
#   -af "atempo=0.5,atempo=0.5"
#                          audio at 0.25× (close to the 0.3× video speed)
#   -r 29.97
#   -c:a aac -b:a 128k -c:v libx264 -crf 21 -pix_fmt yuv420p -preset veryfast
#
# Source:  ffmpeg-utilities/videogrep.sh (the feart-ant command)
# Changed: -filter_complex → -vf; -filter:a → -af
# Tested:  ffmpeg 9.0.2
# Test-fixture: long

ffmpeg -ss 21 -i input.mp4 \
  -vf "random=frames=5,tblend=all_mode=difference,normalize=blackpt=black:whitept=white:smoothing=0,minterpolate=fps=100:scd=none,setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,unsharp" \
  -af "atempo=0.5,atempo=0.5" \
  -r 29.97 \
  -c:a aac -b:a 128k \
  -c:v libx264 -crf 21 -pix_fmt yuv420p -preset veryfast \
  output.mp4
