# ffmpeg-utilities

Real-world ffmpeg commands for transforming video, images and audio, grouped by theme.

Each `.sh` file is a single, copy-paste-ready command or small loop, taken from real projects. The comment header explains what it does and why, what every flag means, which script it came from, and what was changed to bring it up to date. Every ffmpeg example was run against generated test media on ffmpeg 9.0.2.

Each file's `Source:` line names the original script in this repo that the command came from. The originals were removed once converted and are still in the git history.

Most files read `input.mp4` (or `input.mov`, `input.aiff`, `frames/f%05d.jpg`) and write `output.*` in the current folder. Rename the files or edit the paths to fit your project.

## Conversion

| File | What it does |
|---|---|
| [`remux-faststart.sh`](conversion/remux-faststart.sh) | Remux to MP4 with the moov atom at the front (faststart) |
| [`web-mp4-baseline-keep-size.sh`](conversion/web-mp4-baseline-keep-size.sh) | Maximum-compatibility web MP4 at the source's own size |
| [`web-mp4-square-600.sh`](conversion/web-mp4-square-600.sh) | Square 600×600 web MP4: H.264 Baseline with loudness-normalized mono audio |
| [`web-ogv-theora-vorbis.sh`](conversion/web-ogv-theora-vorbis.sh) | Ogg Theora/Vorbis video (open-format HTML5 fallback) |
| [`xvid-roundtrip-crush.sh`](conversion/xvid-roundtrip-crush.sh) | Crush a clip through Xvid, then back to H.264 |

## Resize and crop

| File | What it does |
|---|---|
| [`fill-crop-640x480.sh`](resize-crop/fill-crop-640x480.sh) | Fill a 4:3 640×480 frame at 30 fps (scale up, then center-crop) |
| [`fill-crop-720x480.sh`](resize-crop/fill-crop-720x480.sh) | Fill a 720×480 (NTSC-sized) frame, silent, small file |
| [`scale-offset-crop-1434x1080.sh`](resize-crop/scale-offset-crop-1434x1080.sh) | Crop a near-4:3 1434×1080 window from 1080p footage, at 29.97 fps |
| [`vertical-canvas-414x736.sh`](resize-crop/vertical-canvas-414x736.sh) | Vertical 8-second loop from landscape footage (Spotify Canvas–style) |

## Overlays and compositing

| File | What it does |
|---|---|
| [`center-png-overlay-4x3.sh`](overlay/center-png-overlay-4x3.sh) | Center a PNG overlay on a 4:3 640×480 video, silent |
| [`center-png-overlay-square.sh`](overlay/center-png-overlay-square.sh) | Center a PNG logo or watermark on a square 720×720 video |
| [`overlay-then-sobel.sh`](overlay/overlay-then-sobel.sh) | Composite a centered PNG, then edge-detect the whole frame (4:3 1024×768) |
| [`remove-logo-delogo.sh`](overlay/remove-logo-delogo.sh) | Remove a burned-in logo or timestamp with delogo, at a steady 29.97 fps |
| [`video-mosaic-grid.sh`](overlay/video-mosaic-grid.sh) | Tile up to 100 clips into a 10×10 1920×1080 mosaic with mixed audio |

## Stills and GIFs

| File | What it does |
|---|---|
| [`extract-frame-jpg.sh`](stills-and-gifs/extract-frame-jpg.sh) | Grab a single frame as a 600×600 JPEG (poster image / thumbnail) |
| [`palette-gif.sh`](stills-and-gifs/palette-gif.sh) | High-quality GIF with a custom palette, in one command |

## Timing and slow motion

| File | What it does |
|---|---|
| [`conform-to-2997-prores.sh`](timing/conform-to-2997-prores.sh) | Slow motion by conforming high-frame-rate footage to 29.97 fps (ProRes) |
| [`extreme-slowmo-12x.sh`](timing/extreme-slowmo-12x.sh) | Extreme 12.5× slow motion with motion interpolation (butterflow replacement) |
| [`minterpolate-mode-comparison.sh`](timing/minterpolate-mode-comparison.sh) | Compare minterpolate's motion-estimation settings side by side |
| [`minterpolate-normalize-fps.sh`](timing/minterpolate-normalize-fps.sh) | Convert to a steady 29.97 fps with motion interpolation (no speed change) |
| [`minterpolate-raise-fps.sh`](timing/minterpolate-raise-fps.sh) | Raise footage to 120 fps with interpolated frames, at normal speed |
| [`minterpolate-slowmo-prores.sh`](timing/minterpolate-slowmo-prores.sh) | 4× slow motion with motion-interpolated frames (ProRes) |
| [`minterpolate-slowmo-with-audio.sh`](timing/minterpolate-slowmo-with-audio.sh) | 4× interpolated slow motion with matching slowed audio, square 1080×1080 |

## Effects

| File | What it does |
|---|---|
| [`ditherpunk.sh`](effects/ditherpunk.sh) | Convert video to a 1-bit black-and-white dithered palette |
| [`frei0r-colordistance.sh`](effects/frei0r-colordistance.sh) | Color-distance map with frei0r colordistance |
| [`frei0r-glitch-sobel-baltan.sh`](effects/frei0r-glitch-sobel-baltan.sh) | Glitched edges with afterimage trails (glitch0r + Sobel + Baltan) |
| [`frei0r-glitch-vertigo-nervous.sh`](effects/frei0r-glitch-vertigo-nervous.sh) | Subtle glitches in a spinning, jittering feedback loop (glitch0r + Vertigo + Nervous) |
| [`frei0r-glitch0r-prores.sh`](effects/frei0r-glitch0r-prores.sh) | Digital block glitches with frei0r glitch0r (ProRes) |
| [`frei0r-nervous-slowmo-h264.sh`](effects/frei0r-nervous-slowmo-h264.sh) | "Nervous" 4× slow motion with slowed audio, 4:3 H.264 |
| [`frei0r-nervous-slowmo-prores.sh`](effects/frei0r-nervous-slowmo-prores.sh) | Jittery "nervous" frame shuffling, stretched into 4× slow motion (ProRes) |
| [`frei0r-sobel-edges.sh`](effects/frei0r-sobel-edges.sh) | Sobel edge detection on its own, cropped to 1024×768 |
| [`normalize-levels.sh`](effects/normalize-levels.sh) | Stretch an image sequence's levels to full black and white |
| [`random-difference-glitch.sh`](effects/random-difference-glitch.sh) | Shuffled difference-blend glitch in interpolated slow motion |
| [`shuffleframes-stutter.sh`](effects/shuffleframes-stutter.sh) | Rhythmic stutter: flash back to an anchor frame between every frame |
| [`sobel-edge-glitch.sh`](effects/sobel-edge-glitch.sh) | Edge-detected, warped glitch stack (stutter + blend + Sobel + invert) |

## Audio visualization

| File | What it does |
|---|---|
| [`ahistogram.sh`](audio-visualization/ahistogram.sh) | Audio level histogram video (ahistogram) |
| [`aphasemeter.sh`](audio-visualization/aphasemeter.sh) | Stereo phase meter video (aphasemeter) |
| [`avectorscope-polar.sh`](audio-visualization/avectorscope-polar.sh) | Polar and Lissajous vectorscopes drawn with lines |
| [`avectorscope.sh`](audio-visualization/avectorscope.sh) | Stereo vectorscope (Lissajous / goniometer) video from an audio file |
| [`showcqt.sh`](audio-visualization/showcqt.sh) | Musical spectrum video with showcqt (constant-Q transform) |
| [`showwaves.sh`](audio-visualization/showwaves.sh) | Render an audio file as waveform video, four ways (ProRes for editing) |

## Image sequences

| File | What it does |
|---|---|
| [`gopro-timelapse-start-number.sh`](image-sequence/gopro-timelapse-start-number.sh) | GoPro timelapse photos to a 1080p video, starting mid-sequence |
| [`image-sequence-2-video.sh`](image-sequence/image-sequence-2-video.sh) | Turn a GoPro timelapse image sequence into a 1080p video |
| [`images-to-video-offset-crop.sh`](image-sequence/images-to-video-offset-crop.sh) | Image sequence to video, filled to 1280×720 with a lowered crop |
| [`svg-frames-to-prores4444-alpha.sh`](image-sequence/svg-frames-to-prores4444-alpha.sh) | SVG animation frames to ProRes 4444 with a transparent background |

## Batch processing

| File | What it does |
|---|---|
| [`batch-loop-with-notification.sh`](batch/batch-loop-with-notification.sh) | Run an ffmpeg command over every file in a folder, then announce it's done |
| [`render-visualizer-set.sh`](batch/render-visualizer-set.sh) | Render a set of five audio visualizers for every audio file in a folder |
| [`standardize-batch.sh`](batch/standardize-batch.sh) | Scale a folder of .mov files to 1080p with Baseline H.264 for the web |

## Diagnostics

| File | What it does |
|---|---|
| [`check-ffmpeg-features.sh`](diagnostics/check-ffmpeg-features.sh) | Check that this ffmpeg has the encoders, filters and plugins these examples use |

## Related tools

Separate tools used alongside ffmpeg in the same projects. These are described, not tested here.

| File | What it does |
|---|---|
| [`primitive-png-to-svg.sh`](related-tools/primitive-png-to-svg.sh) | Redraw images as SVGs made of simple shapes, with primitive |
| [`videogrep-supercut.sh`](related-tools/videogrep-supercut.sh) | Transcribe videos and cut a supercut of every time a word is spoken |

## Requirements

- ffmpeg with libx264, libtheora and libvorbis.
- The `effects/` examples that use `frei0r=…` need an ffmpeg built with frei0r (for example the `ffmpeg-full` Homebrew formula). If ffmpeg reports "Could not find module", set `FREI0R_PATH` to the plugin folder (`/opt/homebrew/lib/frei0r-1` with Homebrew on Apple Silicon).
- The ProRes examples use ffmpeg's built-in `prores` / `prores_ks` encoders.
- `image-sequence/svg-frames-to-prores4444-alpha.sh` uses ImageMagick (`magick`) to rasterize SVGs, unless your ffmpeg is built with librsvg.
- Run `diagnostics/check-ffmpeg-features.sh` to see what your ffmpeg build is missing.

## License

[MIT](LICENSE). Earlier versions were published under GPL-3.0-or-later, and those copies keep that license.
