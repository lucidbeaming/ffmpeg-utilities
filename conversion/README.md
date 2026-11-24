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
