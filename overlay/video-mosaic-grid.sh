#!/usr/bin/env bash
# Tile up to 100 clips into a 10×10 1920×1080 mosaic with mixed audio
#
# Builds the filtergraph from the clips in the folder instead of typing
# 100 inputs by hand: each clip is restarted at time zero, scaled and
# cropped to a 192×108 tile, and xstack lays the tiles out in a grid. All
# the audio tracks are mixed together. The original was written out in
# full; xstack's grid option now does the layout math.
#
#   COLS, ROWS             grid size (default 10×10 = 100 tiles); set e.g.
#                          COLS=4 ROWS=4 for 16 clips
#   TILE_W, TILE_H         tile size (default 192×108, so 10×10 = 1920×1080)
#   setpts=PTS-STARTPTS    start every clip at 0 so the tiles play in sync
#   scale=…:force_original_aspect_ratio=increase,crop=…
#                          fill each tile without distortion
#   xstack=inputs=N:grid=COLSxROWS:fill=black
#                          lay out the tiles left to right, top to bottom;
#                          missing tiles stay black
#   amix=inputs=N:normalize=0
#                          mix every clip's audio; normalize=0 keeps each
#                          at full volume (it gets loud with many clips;
#                          remove it to have amix scale them down instead)
#   -shortest              stop when the shortest clip ends
#
# Clips without audio would break amix; drop the audio part (and
# -map "[a]") for silent clips.
#
# Source:  ffmpeg-utilities/notes/mosaic.txt
# Changed: generated with a loop instead of 100 hand-written inputs. That
#          fixes the source's typos: a tile labeled [a111], [a2] used twice,
#          and an amix that listed only 90 of its 100 inputs. The layout
#          now uses xstack grid= in place of 100 hand-written positions.
# Tested:  ffmpeg 9.0.2 (with a 2×2 grid)

COLS=${COLS:-10}
ROWS=${ROWS:-10}
TILE_W=${TILE_W:-192}
TILE_H=${TILE_H:-108}

shopt -s nullglob
clips=( *.mp4 )
clips=( "${clips[@]:0:COLS*ROWS}" )
n=${#clips[@]}
[ "$n" -gt 0 ] || { echo "no .mp4 clips here" >&2; exit 1; }

inputs=() video="" tiles="" audio=""
for i in "${!clips[@]}"; do
  inputs+=( -i "${clips[$i]}" )
  video+="[$i:v]setpts=PTS-STARTPTS,scale=${TILE_W}:${TILE_H}:force_original_aspect_ratio=increase,crop=${TILE_W}:${TILE_H}[t$i];"
  tiles+="[t$i]"
  audio+="[$i:a]"
done

ffmpeg "${inputs[@]}" \
  -filter_complex "${video}${tiles}xstack=inputs=${n}:grid=${COLS}x${ROWS}:fill=black[v];${audio}amix=inputs=${n}:normalize=0[a]" \
  -map "[v]" -map "[a]" \
  -shortest \
  -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
  -c:a aac \
  mosaic.mp4
