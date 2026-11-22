#!/usr/bin/env bash
# GoPro timelapse photos to a 1080p video, starting mid-sequence
#
# GoPro timelapse photos are numbered like G0011231.JPG, G0011232.JPG, ….
# -start_number tells the image reader where the numbering begins (it
# only searches the first few numbers by default), so a sequence that
# starts at 11231 works without renaming. Played at 15 photos per second
# and conformed to 29.97 fps, every photo shows for about two video
# frames.
#
#   -framerate 15          read 15 photos per second of video (lower =
#                          slower timelapse)
#   -start_number 11231    the first number in the sequence
#   -i G00%05d.JPG         "G00" + 5-digit number (G0011231.JPG); match
#                          your camera's naming
#   scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080
#                          fill 1080p (GoPro photos are 4:3)
#   -r 29.97               output at 29.97 fps
#   -an -c:v libx264 -crf 18 -pix_fmt yuv420p -preset ultrafast
#
# See also image-sequence-2-video.sh, the same idea at 3 photos per second.
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: -r 15 before -i → -framerate 15 (the image reader's own option)
# Tested:  ffmpeg 9.0.2
# Test-setup: for n in $(seq 11231 11260); do ffmpeg -loglevel error -f lavfi -i testsrc2=size=640x480 -frames:v 1 G00$n.JPG; done; rm -rf frames input.*

ffmpeg -framerate 15 -start_number 11231 -i G00%05d.JPG \
  -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" \
  -r 29.97 \
  -an \
  -c:v libx264 -crf 18 -pix_fmt yuv420p -preset ultrafast \
  output.mp4
