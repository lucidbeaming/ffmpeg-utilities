# Diagnostics

The scripts in this folder don't convert or edit anything; they ask your ffmpeg build what it can do before you rely on it. Run them first on a new machine or after upgrading ffmpeg, or whenever an example in another folder fails with an unknown encoder, filter or frei0r plugin, to see which pieces are present and which are missing. The header of each script explains what it checks and where it looks.

## check-ffmpeg-features.sh

Run this first on a new machine, or after upgrading or reinstalling ffmpeg, before trying the examples in this collection. It marks each encoder, filter and frei0r plugin the examples call as `ok` or `MISSING`, then reports whether SVG input is available. The header explains how each check works. It confirms only that a component is present, not that a given command will succeed, so it doesn't replace running the script you actually need.

To check your own additions, add names to the `encoders`, `filters` or `plugins` arrays. If your frei0r plugins are in an unusual folder, set `FREI0R_PATH` to that folder before running.

If the output looks wrong:

- Everything is `MISSING`: the script discards ffmpeg's errors, so check that `ffmpeg` is on your `PATH` and runs.
- Results don't match the build you expect: check which `ffmpeg` comes first on your `PATH`.
- The `frei0r` filter is `ok` but plugins are `MISSING`: point `FREI0R_PATH` at the plugin folder. The [frei0r effects](../effects/frei0r-sobel-edges.sh) need these plugins.
- librsvg is not built in: rasterize the SVGs first with [svg-frames-to-prores4444-alpha.sh](../image-sequence/svg-frames-to-prores4444-alpha.sh).
