#!/usr/bin/env bash
# Render an audio file as waveform video, four ways (ProRes for editing)
#
# showwaves draws the audio waveform as video frames. These four styles
# are 1920×1080 at 30 fps over black, with the original audio muxed in,
# ready to composite in an editor (e.g. with a screen blend mode).
#
#   showwaves=…
#     mode=cline           filled, centered line
#     mode=p2p             dots joined point-to-point
#     mode=point           a dot per sample
#     scale=lin|log        linear or logarithmic amplitude (log shows
#                          quiet passages better)
#     split_channels=1     draw left and right separately
#     colors=White|Gray    per-channel colors
#     size=1920x1080:rate=30
#   format=yuv422p10le     10-bit 4:2:2 for ProRes
#   -map "[v]" -map 0:a    take the rendered video and the original audio
#   -c:v prores_ks -profile:v 3
#                          ProRes 422 HQ
#
# Source:  ffmpeg-utilities/wavs.sh
# Changed: format=yuv422p → yuv422p10le (ProRes is 10-bit); removed the
#          redundant -r 30 (the filter's rate=30 sets it); -c:v prores →
#          prores_ks
# Tested:  ffmpeg 9.0.2

ffmpeg -i input.aiff \
  -filter_complex "[0:a]showwaves=mode=cline:scale=lin:colors=White|White:size=1920x1080:rate=30,format=yuv422p10le[v]" \
  -map "[v]" -map 0:a \
  -c:v prores_ks -profile:v 3 \
  waves-cline-lin.mov

ffmpeg -i input.aiff \
  -filter_complex "[0:a]showwaves=mode=cline:scale=log:colors=White|White:size=1920x1080:rate=30,format=yuv422p10le[v]" \
  -map "[v]" -map 0:a \
  -c:v prores_ks -profile:v 3 \
  waves-cline-log.mov

ffmpeg -i input.aiff \
  -filter_complex "[0:a]showwaves=mode=p2p:scale=lin:colors=White|Gray:size=1920x1080:rate=30,format=yuv422p10le[v]" \
  -map "[v]" -map 0:a \
  -c:v prores_ks -profile:v 3 \
  waves-p2p-lin.mov

ffmpeg -i input.aiff \
  -filter_complex "[0:a]showwaves=mode=point:split_channels=1:scale=log:colors=White|White:size=1920x1080:rate=30,format=yuv422p10le[v]" \
  -map "[v]" -map 0:a \
  -c:v prores_ks -profile:v 3 \
  waves-point-split.mov
