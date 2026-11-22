# Convert to 1-bit color palette, dithered
# requires a 16x16 png with just white and black pixels

ffmpeg -i video-input.mp4 -i bw.png -lavfi "paletteuse=dither=sierra2" video-output.mp4
