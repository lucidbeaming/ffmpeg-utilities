# Effects

The scripts in this folder are for stylized and experimental looks rather than delivery: glitches, edge outlines, frame shuffling and stutter, 1-bit dithering, and interpolated slow motion that warps instead of smoothing. Reach for them when you're making visuals for music videos, projection, or LED walls, and chain them by running one script on another's output for layered effects. Most rely on frei0r plugins, so you need an ffmpeg built with frei0r. Several write ProRes for further editing or a rough draft H.264 for previews, and each header explains its flags and what to change for a final render.

## ditherpunk.sh

Reach for this to get a stark, 1-bit look, where every pixel is pure black or pure white and tones are rendered as dither patterns. It suits stylised clips, music visuals and retro computer aesthetics. It is a poor fit when you need to keep color, fine detail or a subtle grade. The header explains the palette image the command needs.

The simplest variation is to swap `bw.png` for another 16x16 PNG that uses two different colors, such as green and black, to get a duotone instead. For a looping image rather than a video, see [palette-gif.sh](../stills-and-gifs/palette-gif.sh).

If the output looks wrong, check these:

- **Gray or colored pixels appear:** the palette PNG probably isn't pure. Make sure it is exactly 16x16 and holds only black and white pixels, with no antialiasing and no gray.
- **The dither looks smeared or muddy:** the MP4 encode is lossy, so it softens the fine pattern. The effect survives best at larger frame sizes.

## frei0r-colordistance.sh

Reach for this when you want a grayscale map of how far each pixel is from one color: as a matte for later compositing, or for a ghostly, solarized look. With the default source color (black), shadows stay dark and everything else brightens. The header explains each flag.

It isn't an edge detector. If you want outlines rather than tonal distance, try `frei0r-sobel-edges.sh` or `sobel-edge-glitch.sh` instead.

The most useful variation is changing the source color, as the header shows with `frei0r=colordistance:0.2/0.6/0.9`. Pick the dominant color of whatever you want to suppress, such as a sky or a backdrop, so it goes dark and the subject stands out.

If the output looks wrong, check these:

- **"Could not find module":** set `FREI0R_PATH` as described in the header.
- **Almost everything is dark:** your source color is too close to most of the frame. Move it away from the dominant tones.
- **Almost everything is bright:** nothing in the footage is near the source color. Sample a color that actually appears in the shot.
