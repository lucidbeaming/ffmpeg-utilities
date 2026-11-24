# Conversion

The scripts in this folder change how a file is packaged or encoded rather than what it shows: rewrapping a container without touching the streams, or re-encoding to a different codec for a specific destination. Most of them prepare video for web pages: a lossless faststart remux, maximum-compatibility H.264 MP4s at the source size or a fixed 600×600, and an Ogg Theora fallback. The Xvid round trip is the exception: it degrades a clip on purpose for a lo-fi compression look.

