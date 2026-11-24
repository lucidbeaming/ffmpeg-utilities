# Batch processing

The scripts in this folder each run an ffmpeg job over every matching file in a folder, keeping each file's base name in its output, so you can process a whole shoot or album in one go instead of file by file. Reach for them when you have many files that need the same treatment, such as rendering a set of visualizers for each audio track or bringing mixed footage to a common 1080p format, or when a long render should run unattended. The loop in `batch-loop-with-notification.sh` is the general pattern: swap any command from the other folders into its body, and its header explains each flag.

## batch-loop-with-notification.sh

The loop the other batch scripts are built on: it runs one ffmpeg command over every `.mp4` in the current folder, writes each result to `out/` under the same base name, and speaks "Process complete" on macOS when the batch finishes. Use it for long unattended renders where you only need to know when it's done. The default body is a stream-copy faststart remux, like [../conversion/remux-faststart.sh](../conversion/remux-faststart.sh).

It's not the right tool for files in subfolders, since the glob only matches the current folder. It also doesn't fit when each file needs different settings.

To adapt it, swap the ffmpeg line for a command from another example and change `*.mp4` or the `out/${name}.mp4` extension to match. The header explains each flag. [standardize-batch.sh](standardize-batch.sh) and [render-visualizer-set.sh](render-visualizer-set.sh) are worked examples of this.

If the output looks wrong:

- **Nothing happens:** run it from inside the folder that holds the videos. With no matching files, the loop silently does nothing.
- **No announcement:** `say` only exists on macOS and is skipped elsewhere.

## render-visualizer-set.sh

Reach for this when you have a folder of `.aiff` tracks and want several looks to choose between in an edit, rather than settling on one up front. Run it from inside that folder. It writes five 1080p MP4s per track next to the originals, each with the source audio. The header explains each flag.

If you only need one look, use a single-filter script instead, such as [`../audio-visualization/showcqt.sh`](../audio-visualization/showcqt.sh) or [`../audio-visualization/showwaves.sh`](../audio-visualization/showwaves.sh). Each track is rendered five times, so a large folder takes a while.

Useful edits:

- Change `*.aiff` to another extension, such as `*.wav`, for other source files.
- Change `1920x1080` on all five lines for a different frame size.
- Delete the lines for visualizers you don't need.

If nothing happens, no files in the current directory matched the glob. If one render fails, the others still run. Look for its error under the track name the script prints.
