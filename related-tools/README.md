# Related tools

The scripts in this folder wrap tools that aren't part of ffmpeg itself and need their own install: primitive, which redraws an image as an SVG built from simple shapes, and videogrep, which transcribes speech and joins every moment a word is spoken into a supercut. Reach for them when ffmpeg alone can't do the job but can handle the steps around it, such as extracting frames before a redraw and reassembling them afterwards, or slowing down, jittering or crushing a finished supercut. Neither script was tested here, so check the header of each for install steps and what every flag does before adapting it.

## primitive-png-to-svg.sh

Use this to turn every PNG in the current folder into a low-poly SVG made of simple shapes, written to `svg/`. It suits stylized stills, posters, and frame-by-frame animation where a rough, painterly look is the point. Skip it when you need fine detail or readable text, or when you have thousands of frames and little time: every image is redrawn from scratch, one shape at a time.

For video, extract frames first (for example with [extract-frame-jpg.sh](../stills-and-gifs/extract-frame-jpg.sh), saved as PNG), run this script, then reassemble the frames with [svg-frames-to-prores4444-alpha.sh](../image-sequence/svg-frames-to-prores4444-alpha.sh) or [image-sequence-2-video.sh](../image-sequence/image-sequence-2-video.sh).

Variations: switch to the commented Bézier line, try another `-m` mode, or change `-n`. The header explains each flag.

If something looks wrong:

- Nothing in `svg/`: the script only matches `*.png` in the current folder and quietly does nothing if there are none.
- `primitive: command not found`: the Go bin folder (often `~/go/bin`) isn't on your `PATH`.
- Too abstract: raise `-n`. Too slow: lower it.

## videogrep-supercut.sh

Reach for this when you have footage of people talking (interviews, lectures, news clips) and want every moment a word or phrase is spoken cut into one video. It's not an ffmpeg command: videogrep is a separate install, and it needs clear speech to transcribe. Music, heavy background noise or silent footage will give poor or empty results. The header explains each flag.

Work in three steps: transcribe once, look at the `--ngrams 1` list to choose a word, then search. To keep clips in their original order, drop `--randomize`. For phrases rather than single words, use the default `sentence` search type instead of `fragment`. The finished supercut can go through [../timing/extreme-slowmo-12x.sh](../timing/extreme-slowmo-12x.sh), [../effects/frei0r-nervous-slowmo-h264.sh](../effects/frei0r-nervous-slowmo-h264.sh) or [../conversion/xvid-roundtrip-crush.sh](../conversion/xvid-roundtrip-crush.sh).

If matches are missing, the transcript probably misheard them. Check how the word appears in the `--ngrams` list, or transcribe again with a larger `--model`. Transcripts are reused, so delete the old `.json` files first. If words sound clipped, raise `--padding` a little.
