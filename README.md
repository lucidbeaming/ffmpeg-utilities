# ffmpeg-commands

A collection of ffmpeg scripts and real-world command examples for transforming video, images and audio.

## Examples

[`examples/`](examples/) holds single ffmpeg commands taken from real projects. Each one is a standalone, copy-paste-ready `.sh` file. Its comment header explains what the command does and why, what every flag means, which script it came from, and what was changed to bring it up to date. Every ffmpeg example was run against generated test media on ffmpeg 9.0.2.

Examples read `input.mp4` (or `input.mov`, `input.aiff`, `frames/f%05d.jpg`) and write `output.*` in the current folder. Rename the files or edit the paths to fit your project.

### Conversion

| Example | What it does |
|---|---|
| [`remux-faststart.sh`](examples/conversion/remux-faststart.sh) | Remux to MP4 with the moov atom at the front (faststart) |
| [`web-mp4-square-600.sh`](examples/conversion/web-mp4-square-600.sh) | Square 600×600 web MP4: H.264 Baseline with loudness-normalized mono audio |
| [`web-ogv-theora-vorbis.sh`](examples/conversion/web-ogv-theora-vorbis.sh) | Ogg Theora/Vorbis video (open-format HTML5 fallback) |
| [`xvid-roundtrip-crush.sh`](examples/conversion/xvid-roundtrip-crush.sh) | Crush a clip through Xvid, then back to H.264 |

### Resize and crop

| Example | What it does |
|---|---|
| [`fill-crop-640x480.sh`](examples/resize-crop/fill-crop-640x480.sh) | Fill a 4:3 640×480 frame at 30 fps (scale up, then center-crop) |
| [`fill-crop-720x480.sh`](examples/resize-crop/fill-crop-720x480.sh) | Fill a 720×480 (NTSC-sized) frame, silent, small file |
| [`scale-offset-crop-1434x1080.sh`](examples/resize-crop/scale-offset-crop-1434x1080.sh) | Crop a near-4:3 1434×1080 window from 1080p footage, at 29.97 fps |
| [`vertical-canvas-414x736.sh`](examples/resize-crop/vertical-canvas-414x736.sh) | Vertical 8-second loop from landscape footage (Spotify Canvas–style) |

### Overlays

| Example | What it does |
|---|---|
| [`center-png-overlay-4x3.sh`](examples/overlay/center-png-overlay-4x3.sh) | Center a PNG overlay on a 4:3 640×480 video, silent |
| [`center-png-overlay-square.sh`](examples/overlay/center-png-overlay-square.sh) | Center a PNG logo or watermark on a square 720×720 video |

### Stills and GIFs

| Example | What it does |
|---|---|
| [`extract-frame-jpg.sh`](examples/stills-and-gifs/extract-frame-jpg.sh) | Grab a single frame as a 600×600 JPEG (poster image / thumbnail) |
| [`palette-gif.sh`](examples/stills-and-gifs/palette-gif.sh) | High-quality GIF with a custom palette, in one command |

### Timing and slow motion

| Example | What it does |
|---|---|
| [`conform-to-2997-prores.sh`](examples/timing/conform-to-2997-prores.sh) | Slow motion by conforming high-frame-rate footage to 29.97 fps (ProRes) |
| [`extreme-slowmo-12x.sh`](examples/timing/extreme-slowmo-12x.sh) | Extreme 12.5× slow motion with motion interpolation (butterflow replacement) |
| [`minterpolate-mode-comparison.sh`](examples/timing/minterpolate-mode-comparison.sh) | Compare minterpolate's motion-estimation settings side by side |
| [`minterpolate-normalize-fps.sh`](examples/timing/minterpolate-normalize-fps.sh) | Convert to a steady 29.97 fps with motion interpolation (no speed change) |
| [`minterpolate-slowmo-prores.sh`](examples/timing/minterpolate-slowmo-prores.sh) | 4× slow motion with motion-interpolated frames (ProRes) |
| [`minterpolate-slowmo-with-audio.sh`](examples/timing/minterpolate-slowmo-with-audio.sh) | 4× interpolated slow motion with matching slowed audio, square 1080×1080 |

### Effects

| Example | What it does |
|---|---|
| [`frei0r-nervous-slowmo-h264.sh`](examples/effects/frei0r-nervous-slowmo-h264.sh) | "Nervous" 4× slow motion with slowed audio, 4:3 H.264 |
| [`frei0r-nervous-slowmo-prores.sh`](examples/effects/frei0r-nervous-slowmo-prores.sh) | Jittery "nervous" frame shuffling, stretched into 4× slow motion (ProRes) |
| [`normalize-levels.sh`](examples/effects/normalize-levels.sh) | Stretch an image sequence's levels to full black and white |
| [`random-difference-glitch.sh`](examples/effects/random-difference-glitch.sh) | Shuffled difference-blend glitch in interpolated slow motion |
| [`shuffleframes-stutter.sh`](examples/effects/shuffleframes-stutter.sh) | Rhythmic stutter: flash back to an anchor frame between every frame |
| [`sobel-edge-glitch.sh`](examples/effects/sobel-edge-glitch.sh) | Edge-detected, warped glitch stack (stutter + blend + Sobel + invert) |

### Audio visualization

| Example | What it does |
|---|---|
| [`avectorscope.sh`](examples/audio-visualization/avectorscope.sh) | Stereo vectorscope (Lissajous / goniometer) video from an audio file |
| [`showwaves.sh`](examples/audio-visualization/showwaves.sh) | Render an audio file as waveform video, four ways (ProRes for editing) |

### Image sequences

| Example | What it does |
|---|---|
| [`images-to-video-offset-crop.sh`](examples/image-sequence/images-to-video-offset-crop.sh) | Image sequence to video, filled to 1280×720 with a lowered crop |

### Batch processing

| Example | What it does |
|---|---|
| [`batch-loop-with-notification.sh`](examples/batch/batch-loop-with-notification.sh) | Run an ffmpeg command over every file in a folder, then announce it's done |

### Related tools

Separate tools used alongside ffmpeg in the same projects. These are described, not tested here.

| Example | What it does |
|---|---|
| [`primitive-png-to-svg.sh`](examples/related-tools/primitive-png-to-svg.sh) | Redraw images as SVGs made of simple shapes, with primitive |
| [`videogrep-supercut.sh`](examples/related-tools/videogrep-supercut.sh) | Transcribe videos and cut a supercut of every time a word is spoken |

### Requirements

- ffmpeg with libx264, libtheora and libvorbis. The `effects/` examples that use `frei0r=…` need an ffmpeg built with frei0r (for example the `ffmpeg-full` Homebrew formula). If ffmpeg reports "Could not find module", set `FREI0R_PATH` to the plugin folder (`/opt/homebrew/lib/frei0r-1` with Homebrew on Apple Silicon).
- The ProRes examples use ffmpeg's built-in `prores` / `prores_ks` encoders.

## Scripts

| Script | What it does |
|---|---|
| [`ditherpunk.sh`](ditherpunk.sh) | Convert to a 1-bit dithered palette |
| [`image-sequence-2-video.sh`](image-sequence-2-video.sh) | Turn a GoPro timelapse image sequence into a 1080p video |
| [`standardize-batch.sh`](standardize-batch.sh) | Scale a folder of .mov files to 1080p with Baseline H.264 for the web |
