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

## frei0r-glitch-sobel-baltan.sh

Reach for this when you want footage reduced to glowing, broken outlines that smear as things move. It suits music videos, title backdrops and loops, especially with clear motion against a plain background. Baltan's trails come from frame-to-frame change, so static shots get the edges but little ghosting. The header explains each filter in the chain.

Skip it when you need clean, readable edges. [frei0r-sobel-edges.sh](frei0r-sobel-edges.sh) is the simpler starting point. For glitching without the edge pass, try [frei0r-glitch0r-prores.sh](frei0r-glitch0r-prores.sh) or [frei0r-glitch-vertigo-nervous.sh](frei0r-glitch-vertigo-nervous.sh).

Useful variations:

- Lower the four glitch0r numbers for occasional damage instead of constant breakup.
- Drop `,frei0r=baltan` for crisp glitched edges without trails.
- Change `-r 29.97` to match your source or delivery rate.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If the result is mostly black, the source probably has low contrast or soft focus, which gives Sobel few edges to find.

## frei0r-glitch-vertigo-nervous.sh

Reach for this when you want a hypnotic, unstable look: a swirling feedback tunnel that twitches as frames get shuffled, with only occasional block glitches on top. It suits music visuals, loops and title backgrounds. Skip it when motion needs to read clearly or lip sync matters, because Nervous scrambles the order of recent frames. For a gentler stutter, try [shuffleframes-stutter.sh](shuffleframes-stutter.sh). For edge-based glitching, see [frei0r-glitch-sobel-baltan.sh](frei0r-glitch-sobel-baltan.sh). The header explains each filter.

Variations:

- Change `-r 29.97` to match your source's frame rate.
- Pass Vertigo's two parameters, phase increment and zoom rate, to change how fast the tunnel spins and zooms.
- Swap in [frei0r-glitch0r-prores.sh](frei0r-glitch0r-prores.sh) if you only want the block glitching.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If the glitches seem to be missing, that's expected: the glitch0r values are deliberately rare and small.

## frei0r-glitch0r-prores.sh

Use this when you want blocky, damaged-signal glitches on a clip that's going back into an editor. The ProRes 422 output holds up through further cutting and grading. The default values are gentle: occasional sideways block shifts with no color damage. For a final web upload, encode the result separately, because the `.mov` file is large. The header explains each flag.

Useful variations:

- For heavier damage, try the source's stronger values `0.3|0.3|0.6|0.3`, which also turn on color glitching.
- Keep the gentle shifts but add color damage by raising only the last value above 0.
- Change `input.mp4` and `output.mov` to your own file names.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If the output looks barely touched, the first value (glitch frequency) is probably too low for your clip, so raise it. For a different glitch look, see [random-difference-glitch.sh](random-difference-glitch.sh).

## frei0r-nervous-slowmo-h264.sh

Reach for this when you want the jittery, dreamlike "nervous" slow motion as a file you can post or send straight away. It keeps the sound, slowed to match, and encodes a 640×480 H.264 file that most players handle. If you plan to keep editing or grading the result, use [frei0r-nervous-slowmo-prores.sh](frei0r-nervous-slowmo-prores.sh) instead. For plain slow motion without the jitter, see [../timing/minterpolate-slowmo-with-audio.sh](../timing/minterpolate-slowmo-with-audio.sh). The header explains each flag.

Variations from the source:

- Change both `640:480` pairs to `1920:1080` for a widescreen frame.
- For a 2× slowdown, interpolate to 60 fps and use a single `atempo=0.5`.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If sound and picture drift apart, check that the number of `atempo=0.5` stages matches the slowdown. Expect a slow render and an output about four times longer than the input. Blended cuts are intentional. Missing picture at the edges comes from the fill crop.

## frei0r-nervous-slowmo-prores.sh

Reach for this when you want twitchy, out-of-order motion turned into slow, smeared warping, and you plan to keep editing or grading the result. ProRes 422 10-bit holds up better through further processing than a delivery codec. For a smaller file to share directly, use the H.264 counterpart, [frei0r-nervous-slowmo-h264.sh](frei0r-nervous-slowmo-h264.sh). For clean slow motion without the jitter, see [../timing/minterpolate-slowmo-prores.sh](../timing/minterpolate-slowmo-prores.sh). The header explains each flag.

To change the slowdown, edit the minterpolate rate. `fps=60` gives roughly 2× slow motion instead of 4×. If you change the playback rate, change it in both `setpts` and `-r` so they stay matched. The script drops audio, so add any sound in your editor.

If the output looks wrong or the command fails:

- "Could not find module": set `FREI0R_PATH` as the header shows.
- frei0r isn't recognised at all: your ffmpeg was built without it.
- Rendering is slow: expect this, because minterpolate is slow.
- The file is large: expect this from ProRes.
