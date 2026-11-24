# Audio visualization

The scripts in this folder each turn an audio file into a video that shows something about the sound: its waveform, its spectrum on a musical scale, its loudness distribution, or how its left and right channels relate. Each one renders the visualization with the original audio muxed in, either as H.264 for quick viewing and sharing or as ProRes 422 HQ for compositing in an editor. Reach for them when you need a visual to go with a music track, or when you want to check a mix's dynamic range, stereo width or mono compatibility by eye. The header in each script explains every flag.

## ahistogram.sh

Use this when you want to see a track's dynamic range rather than its shape or pitch. It works well for comparing two masters of the same song, or for checking whether a mix has been squashed. Quiet, dynamic material spreads wide. Heavily compressed audio piles up near the top. The header explains each flag.

For other views, reach for a different script:

- [showwaves.sh](showwaves.sh) for the waveform over time.
- [showcqt.sh](showcqt.sh) for pitch and frequency content.
- [avectorscope.sh](avectorscope.sh) or [aphasemeter.sh](aphasemeter.sh) for stereo image and phase.

To adapt it, change `input.aiff` and `output.mp4` to your own file names. The output uses the filter's defaults of 1280×720 at 25 fps.

If the output looks wrong:

- **Histogram bunched at the top:** this is usually the master being loud and compressed, not a bug.
- **No sound:** confirm `-map 0:a` is still present.
- **File won't play in some players:** check that `format=yuv420p` wasn't removed.
- **Command fails immediately:** make sure the input actually contains an audio stream.

## aphasemeter.sh

Reach for `aphasemeter.sh` to check whether a stereo mix will survive being summed to mono, for example before sending audio to broadcast, phone speakers or a mono club system. It renders the meter as a video with the original audio alongside, so you can scrub to the moments where the bar swings left. The header explains each flag and how to read the meter.

It measures how the left and right channels relate to each other, so it only tells you something about stereo sources. For a picture of stereo width rather than a single phase reading, use [avectorscope.sh](avectorscope.sh) or [avectorscope-polar.sh](avectorscope-polar.sh).

Useful edits:

- Change `s=1280x720` to match the frame size of whatever the meter will be shown in.
- Change `mpc=cyan` to another color if the median line is hard to see against the bars.
- Swap `input.aiff` and `output.mp4` for your own file names.

If ffmpeg refuses to build the filter graph, check that both `aphasemeter` outputs are still labeled `[a][pv]` and that `format=` reads from `[pv]`. Chaining `format=` straight onto `aphasemeter` is the failure the header's "Changed" note describes. If the MP4 won't play in some players, make sure the `format=yuv420p` step is still in the chain.
