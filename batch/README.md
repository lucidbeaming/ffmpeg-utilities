# Batch processing

The scripts in this folder each run an ffmpeg job over every matching file in a folder, keeping each file's base name in its output, so you can process a whole shoot or album in one go instead of file by file. Reach for them when you have many files that need the same treatment, such as rendering a set of visualizers for each audio track or bringing mixed footage to a common 1080p format, or when a long render should run unattended. The loop in `batch-loop-with-notification.sh` is the general pattern: swap any command from the other folders into its body, and its header explains each flag.

## batch-loop-with-notification.sh

The loop the other batch scripts are built on: it runs one ffmpeg command over every `.mp4` in the current folder, writes each result to `out/` under the same base name, and speaks "Process complete" on macOS when the batch finishes. Use it for long unattended renders where you only need to know when it's done. The default body is a stream-copy faststart remux, like [../conversion/remux-faststart.sh](../conversion/remux-faststart.sh).

It's not the right tool for files in subfolders, since the glob only matches the current folder. It also doesn't fit when each file needs different settings.

To adapt it, swap the ffmpeg line for a command from another example and change `*.mp4` or the `out/${name}.mp4` extension to match. The header explains each flag. [standardize-batch.sh](standardize-batch.sh) and [render-visualizer-set.sh](render-visualizer-set.sh) are worked examples of this.

If the output looks wrong:

- **Nothing happens:** run it from inside the folder that holds the videos. With no matching files, the loop silently does nothing.
- **No announcement:** `say` only exists on macOS and is skipped elsewhere.
