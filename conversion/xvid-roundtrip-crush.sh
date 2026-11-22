#!/usr/bin/env bash
# Crush a clip through Xvid, then back to H.264
#
# A generation-loss look: encoding to MPEG-4 Part 2 at ffmpeg's low default
# bitrate (200 kb/s) bakes in blocky early-2000s compression artifacts. The
# second pass re-encodes that damaged video to H.264 so it can be shared,
# keeping the artifacts intact.
#
# Step 1
#   -c:v mpeg4 -vtag xvid  MPEG-4 Part 2, tagged with the XVID fourcc so
#                          players and editors treat it as an Xvid AVI
#                          (no -b:v, so the 200 kb/s default does the damage)
# Step 2
#   -r 30                  output at 30 fps
#   -c:a aac -b:a 128k     AAC audio, 128 kb/s
#   -c:v libx264 -crf 18 -preset veryfast
#                          high-quality H.264, so no new damage is added
#   -pix_fmt yuv420p       4:2:0 for player compatibility
#
# Source:  ffmpeg-utilities/videogrep.sh (the emot-avi / emot-crush steps)
# Changed: fixed the "0c:a" typo in step 2 (→ -c:a); added -pix_fmt yuv420p
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.mp4 \
  -c:v mpeg4 -vtag xvid \
  crushed.avi

ffmpeg -i crushed.avi \
  -r 30 \
  -c:a aac -b:a 128k \
  -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p \
  output.mp4
