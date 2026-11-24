# Batch processing

The scripts in this folder each run an ffmpeg job over every matching file in a folder, keeping each file's base name in its output, so you can process a whole shoot or album in one go instead of file by file. Reach for them when you have many files that need the same treatment, such as rendering a set of visualizers for each audio track or bringing mixed footage to a common 1080p format, or when a long render should run unattended. The loop in `batch-loop-with-notification.sh` is the general pattern: swap any command from the other folders into its body, and its header explains each flag.

