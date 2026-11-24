# Conversion

The scripts in this folder change how a file is packaged or encoded rather than what it shows: rewrapping a container without touching the streams, or re-encoding to a different codec for a specific destination. Most of them prepare video for web pages: a lossless faststart remux, maximum-compatibility H.264 MP4s at the source size or a fixed 600×600, and an Ogg Theora fallback. The Xvid round trip is the exception: it degrades a clip on purpose for a lo-fi compression look.

## remux-faststart.sh

Reach for this when a video already uses codecs a browser can play, but sits in a .mov, or in an MP4 that won't start playing until it has fully downloaded. Nothing is re-encoded, so it runs about as fast as the file can be copied and quality is unchanged. The header explains each flag.

It can't fix the codecs themselves. A ProRes or other editing-format .mov becomes an MP4 that a browser still won't play. For those, re-encode with a script such as [web-mp4-baseline-keep-size.sh](web-mp4-baseline-keep-size.sh) instead.

To adapt it, change `input.mov` and `output.mp4`. An existing MP4 works as input too. Keep `+faststart` for anything played on the web.

If the output looks wrong:

- ffmpeg stops with an error about a codec or tag: one of the streams can't go into an MP4 container as-is, so it needs a re-encode.
- The file plays locally but not in the browser: the source codecs aren't web-friendly.
- An extra audio track or subtitle stream is missing: by default ffmpeg keeps one stream of each type, not every stream.

## web-mp4-baseline-keep-size.sh

Reach for this when a clip is already the size you want on the page but its encoding won't play everywhere, such as an iPhone HEVC clip or a ProRes export. It re-encodes video and audio and leaves the frame size alone. The header explains each flag.

Skip it if the encoding is already fine and only faststart is missing; [remux-faststart.sh](remux-faststart.sh) handles that case. If the frame size also needs to change, use [web-mp4-square-600.sh](web-mp4-square-600.sh) or [fill-crop-640x480.sh](../resize-crop/fill-crop-640x480.sh). Level 4.1 only goes up to 1080p, so resize anything larger first.

Variations:
- For sources at 720p or smaller, use `-level:v 3.1`, as the original note did.
- Use the note's square variant: `scale=720:720` with `-crf 23` and `-c:a copy` to keep the original audio.
- Raise `-crf` for smaller files, or lower it for higher quality.

If the encode fails or a player rejects the file, first check that the source is no larger than 1080p. Then check that its width and height are even numbers, which 4:2:0 output requires.

## web-mp4-square-600.sh

Use this when you need a small square clip that plays almost anywhere, such as an embedded preview, a thumbnail video or a social-style tile. It favours compatibility and consistent volume over quality. The header explains each flag.

Don't use it for non-square footage you care about. `scale=600:600` stretches the picture instead of cropping it, so crop first with one of the scripts in the `resize-crop/` theme, or keep the original dimensions with [web-mp4-baseline-keep-size.sh](web-mp4-baseline-keep-size.sh).

Useful variations:

- Change both `600` values for a different square size.
- Lower `-crf 20` for better quality and bigger files, or raise it for smaller ones.
- Change `-ac 1` to `-ac 2` to keep stereo.

If the output looks wrong:

- Squashed or stretched picture: the source wasn't square.
- Volume differs from the original: this is `loudnorm` working as intended, and it is a single pass.
- Playback waits for the full download: check that `-movflags +faststart` survived your edits.
