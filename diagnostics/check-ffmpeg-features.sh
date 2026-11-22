#!/usr/bin/env bash
# Check that this ffmpeg has the encoders, filters and plugins these examples use
#
# Lists each encoder and filter used in this repo as ok or MISSING, then
# checks for the frei0r plugins and optional SVG support. Asking ffmpeg
# what it can actually do (-encoders, -filters) is more reliable than
# matching ./configure flags, whose names change between versions.
#
#   ffmpeg -hide_banner -encoders / -filters / -decoders
#                          the capability lists to search
#   FREI0R_PATH            where ffmpeg looks for frei0r plugins; this
#                          script checks it plus the usual default folders
#                          and Homebrew's /opt/homebrew/lib/frei0r-1
#
# Source:  ffmpeg-utilities/notes/commands2.txt
# Changed: the original grepped ffmpeg's banner for --enable-… configure
#          flags, including several (libfaac, libspeex, libopenjpeg) that
#          are long gone or renamed. This version checks what the examples
#          actually call.
# Tested:  ffmpeg 9.0.2

encoders=(libx264 aac libtheora libvorbis prores prores_ks mpeg4)
filters=(minterpolate frei0r normalize tblend tmix shuffleframes random
  unsharp delogo xstack amix loudnorm atempo palettegen paletteuse
  showwaves showcqt avectorscope aphasemeter ahistogram)
plugins=(nervous sobel invert0r distort0r glitch0r colordistance baltan vertigo)

check() {
  local kind=$1; shift
  local list; list="$(ffmpeg -hide_banner -"$kind" 2>/dev/null)"
  for name in "$@"; do
    if grep -qE "^ [^ ]+ ${name} " <<<"$list"; then
      echo "ok       $kind: $name"
    else
      echo "MISSING  $kind: $name"
    fi
  done
}

check encoders "${encoders[@]}"
check filters "${filters[@]}"

dirs=( ${FREI0R_PATH//:/ } "$HOME/.frei0r-1/lib" /usr/local/lib/frei0r-1 /usr/lib/frei0r-1 /opt/homebrew/lib/frei0r-1 )
for p in "${plugins[@]}"; do
  found=""
  for d in "${dirs[@]}"; do [ -e "$d/$p.so" ] && found="$d" && break; done
  if [ -n "$found" ]; then echo "ok       frei0r: $p ($found)"; else echo "MISSING  frei0r: $p"; fi
done

if ffmpeg -hide_banner -decoders 2>/dev/null | grep -qi librsvg; then
  echo "ok       decoder: librsvg (SVG input)"
else
  echo "optional decoder: librsvg not built in; rasterize SVGs first (see image-sequence/svg-frames-to-prores4444-alpha.sh)"
fi
