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

## avectorscope-polar.sh

Use this when you want the stereo field drawn as a continuous trace rather than the dot cloud of [avectorscope.sh](avectorscope.sh). The polar fan reads like a hardware goniometer, which makes it a good stereo-image check you can watch alongside the music. The Lissajous version is more decorative: tones trace looping figures that suit visualizer videos. Skip both for mono sources, since identical channels collapse to a single line. For a dedicated phase readout, see [aphasemeter.sh](aphasemeter.sh).

The script renders both styles in one run. Delete the command you don't need, and change `input.aiff`, the output names or `size=1280x720` to fit your project. The header explains each flag. Don't pass several files with a glob; use [../batch/render-visualizer-set.sh](../batch/render-visualizer-set.sh) instead.

If the output looks wrong:

- A tiny trace huddled in the centre means the zoom is too low for quiet material, so raise it.
- A trace that floods the frame or runs off the edges means the zoom is too high for loud material, so lower it.

## avectorscope.sh

The header explains each flag. Reach for this when you want to see stereo image at a glance: a check on whether a mix is mono, narrow or wide, or a rendered visual to sit alongside the music. Because it writes ProRes 422 HQ with the audio included, the result drops straight into an editing timeline. For a single phase-correlation reading over time, [aphasemeter.sh](aphasemeter.sh) is clearer. For a different take on the same left/right plot, see [avectorscope-polar.sh](avectorscope-polar.sh).

Useful edits:

- Change `size=1920x1080` and `-r 30` to match your project's frame size and rate.
- Lower `zoom=2` if loud passages run off the edges of the frame.
- Swap `input.aiff` for any audio file ffmpeg can read.

If the output looks wrong, check these:

- **A single vertical line:** the source is mono or dual-mono. That's expected, and this script won't show much else.
- **A mostly horizontal line:** the channels are largely out of phase.
- **Large files:** ProRes HQ produces large files. Plan disk space for long tracks.

## showcqt.sh

Reach for this when the audio is music and you want viewers to see pitch: melodies, chords and bass lines show up as distinct bands, because each octave gets equal width. It suits music videos, harmony demonstrations or checking a mix for clashing notes. For speech, noise or sound effects, the musical scale adds little. Use [showwaves.sh](showwaves.sh) for a waveform, or [avectorscope.sh](avectorscope.sh) and [aphasemeter.sh](aphasemeter.sh) to inspect the stereo image instead.

The header explains each flag. Useful edits:

- Change `size=1280x720` to match your target, such as `1920x1080` for a 1080p upload.
- Drop `text=0` to show note-name labels. The header notes the labels need a font, so expect a font error if none is available.
- Swap `input.aiff` for any audio file ffmpeg can read.

If the video plays but is silent, check that `-map 0:a` survived your edits. If a player rejects the file, make sure `format=yuv420p` is still in the filter chain.
