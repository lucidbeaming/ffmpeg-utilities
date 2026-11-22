#!/usr/bin/env bash
# Render a set of five audio visualizers for every audio file in a folder
#
# For each .aiff, renders five 1080p videos to pick from in an edit: two
# polar vectorscopes at different zooms, a Lissajous vectorscope, a
# constant-Q spectrum and a point-to-point waveform in soft gray and
# cream. Each output is named after the audio file plus a suffix.
#
#   -v1, -v2               avectorscope polar, zoom 9 and 6, drawn as lines
#   -v3                    avectorscope lissajous_xy, zoom 3
#   -cqt                   showcqt without labels
#   -wvs                   showwaves p2p, colors 0xA9A9A9|0xFDF5E6 (per channel)
#   -map "[v]" -map 0:a    each visualizer plus the original audio
#   -nostdin               keep ffmpeg from reading the loop's input
#
# Source:  ffmpeg-utilities/notes/ffmpeg-filters.txt
# Changed: the source chained the first commands with && but not the
#          rest, so a failure stopped some renders and not others; each
#          render is now independent. Added nullglob, nocaseglob and
#          -nostdin; name=`echo …` → "${f%.*}".
# Tested:  ffmpeg 9.0.2

shopt -s nullglob nocaseglob

for f in *.aiff; do
  name="${f%.*}"
  echo "$name"
  ffmpeg -nostdin -i "$f" -filter_complex "[0:a]avectorscope=size=1920x1080:mode=polar:zoom=9:draw=line,format=yuv420p[v]" -map "[v]" -map 0:a "${name}-v1.mp4"
  ffmpeg -nostdin -i "$f" -filter_complex "[0:a]avectorscope=size=1920x1080:mode=polar:zoom=6:draw=line,format=yuv420p[v]" -map "[v]" -map 0:a "${name}-v2.mp4"
  ffmpeg -nostdin -i "$f" -filter_complex "[0:a]avectorscope=size=1920x1080:mode=lissajous_xy:zoom=3:draw=line,format=yuv420p[v]" -map "[v]" -map 0:a "${name}-v3.mp4"
  ffmpeg -nostdin -i "$f" -filter_complex "[0:a]showcqt=size=1920x1080:text=0,format=yuv420p[v]" -map "[v]" -map 0:a "${name}-cqt.mp4"
  ffmpeg -nostdin -i "$f" -filter_complex "[0:a]showwaves=size=1920x1080:mode=p2p:scale=lin:colors=0xA9A9A9|0xFDF5E6,format=yuv420p[v]" -map "[v]" -map 0:a "${name}-wvs.mp4"
done
