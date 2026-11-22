#!/usr/bin/env bash
# Run an ffmpeg command over every file in a folder, then announce it's done
#
# The loop pattern behind most of these examples: process each matching
# file into out/, keeping the base name, and speak a notification on macOS
# when the batch finishes, so long renders can run unattended.
#
#   shopt -s nullglob      no matches → no iterations (instead of a literal
#                          "*.mp4")
#   shopt -s nocaseglob    *.mp4 also matches .MP4 (camera files)
#   mkdir -p out           write results to a separate folder, so outputs
#                          aren't picked up as inputs and inputs aren't
#                          overwritten
#   "${f%.*}"              file name without its extension
#   ffmpeg -nostdin        keep ffmpeg from reading the terminal, which
#                          otherwise can swallow input meant for the loop
#   say                    macOS text-to-speech (skipped where unavailable)
#
# Swap in any command from the other examples as the loop body.
#
# Source:  the loops in ffmpeg-utilities (batch.sh, batch 2.sh, faststart.sh,
#          overlay.sh, …)
# Changed: name=`echo "${i%.*}"` → name="${f%.*}"; added nullglob,
#          nocaseglob, mkdir -p and -nostdin; say -v Alex → say (the Alex
#          voice isn't installed by default on current macOS)
# Tested:  ffmpeg 9.0.2

shopt -s nullglob nocaseglob
mkdir -p out

for f in *.mp4; do
  name="${f%.*}"
  echo "$name"
  ffmpeg -nostdin -i "$f" \
    -c copy -movflags +faststart \
    "out/${name}.mp4"
done

command -v say >/dev/null && say "Process complete"
