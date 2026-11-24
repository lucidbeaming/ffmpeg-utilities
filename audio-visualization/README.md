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
