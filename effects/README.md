# Effects

The scripts in this folder are for stylized and experimental looks rather than delivery: glitches, edge outlines, frame shuffling and stutter, 1-bit dithering, and interpolated slow motion that warps instead of smoothing. They're used when you're making visuals for music videos, projection, or LED walls, and chain them by running one script on another's output for layered effects. Most rely on frei0r plugins, so you need an ffmpeg built with frei0r. Several write ProRes for further editing or a rough draft H.264 for previews, and each header explains its flags and what to change for a final render.

## ditherpunk.sh

This is used to get a stark, 1-bit look, where every pixel is pure black or pure white and tones are rendered as dither patterns. It suits stylised clips, music visuals and retro computer aesthetics. It is a poor fit when you need to keep color, fine detail or a subtle grade. The header explains the palette image the command needs.

The simplest variation is to swap `bw.png` for another 16x16 PNG that uses two different colors, such as green and black, to get a duotone instead. For a looping image rather than a video, see [palette-gif.sh](../stills-and-gifs/palette-gif.sh).

If the output looks wrong, check these:

- **Gray or colored pixels appear:** the palette PNG probably isn't pure. Make sure it is exactly 16x16 and holds only black and white pixels, with no antialiasing and no gray.
- **The dither looks smeared or muddy:** the MP4 encode is lossy, so it softens the fine pattern. The effect survives best at larger frame sizes.

## frei0r-colordistance.sh

This is used when you want a grayscale map of how far each pixel is from one color: as a matte for later compositing, or for a ghostly, solarized look. With the default source color (black), shadows stay dark and everything else brightens. The header explains each flag.

It isn't an edge detector. If you want outlines rather than tonal distance, try `frei0r-sobel-edges.sh` or `sobel-edge-glitch.sh` instead.

The most useful variation is changing the source color, as the header shows with `frei0r=colordistance:0.2/0.6/0.9`. Pick the dominant color of whatever you want to suppress, such as a sky or a backdrop, so it goes dark and the subject stands out.

If the output looks wrong, check these:

- **"Could not find module":** set `FREI0R_PATH` as described in the header.
- **Almost everything is dark:** your source color is too close to most of the frame. Move it away from the dominant tones.
- **Almost everything is bright:** nothing in the footage is near the source color. Sample a color that actually appears in the shot.

## frei0r-glitch-sobel-baltan.sh

This is for when you want footage reduced to glowing, broken outlines that smear as things move. It suits music videos, title backdrops and loops, especially with clear motion against a plain background. Baltan's trails come from frame-to-frame change, so static shots get the edges but little ghosting. The header explains each filter in the chain.

Skip it when you need clean, readable edges. [frei0r-sobel-edges.sh](frei0r-sobel-edges.sh) is the simpler starting point. For glitching without the edge pass, try [frei0r-glitch0r-prores.sh](frei0r-glitch0r-prores.sh) or [frei0r-glitch-vertigo-nervous.sh](frei0r-glitch-vertigo-nervous.sh).

Useful variations:

- Lower the four glitch0r numbers for occasional damage instead of constant breakup.
- Drop `,frei0r=baltan` for crisp glitched edges without trails.
- Change `-r 29.97` to match your source or delivery rate.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If the result is mostly black, the source probably has low contrast or soft focus, which gives Sobel few edges to find.

## frei0r-glitch-vertigo-nervous.sh

Useful when you want a hypnotic, unstable look: a swirling feedback tunnel that twitches as frames get shuffled, with only occasional block glitches on top. It suits music visuals, loops and title backgrounds. Skip it when motion needs to read clearly or lip sync matters, because Nervous scrambles the order of recent frames. For a gentler stutter, try [shuffleframes-stutter.sh](shuffleframes-stutter.sh). For edge-based glitching, see [frei0r-glitch-sobel-baltan.sh](frei0r-glitch-sobel-baltan.sh). The header explains each filter.

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

This is useful when you want the jittery, dreamlike "nervous" slow motion as a file you can post or send straight away. It keeps the sound, slowed to match, and encodes a 640×480 H.264 file that most players handle. If you plan to keep editing or grading the result, use [frei0r-nervous-slowmo-prores.sh](frei0r-nervous-slowmo-prores.sh) instead. For plain slow motion without the jitter, see [../timing/minterpolate-slowmo-with-audio.sh](../timing/minterpolate-slowmo-with-audio.sh). The header explains each flag.

Variations from the source:

- Change both `640:480` pairs to `1920:1080` for a widescreen frame.
- For a 2× slowdown, interpolate to 60 fps and use a single `atempo=0.5`.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If sound and picture drift apart, check that the number of `atempo=0.5` stages matches the slowdown. Expect a slow render and an output about four times longer than the input. Blended cuts are intentional. Missing picture at the edges comes from the fill crop.

## frei0r-nervous-slowmo-prores.sh

This is used when you want twitchy, out-of-order motion turned into slow, smeared warping, and you plan to keep editing or grading the result. ProRes 422 10-bit holds up better through further processing than a delivery codec. For a smaller file to share directly, use the H.264 counterpart, [frei0r-nervous-slowmo-h264.sh](frei0r-nervous-slowmo-h264.sh). For clean slow motion without the jitter, see [../timing/minterpolate-slowmo-prores.sh](../timing/minterpolate-slowmo-prores.sh). The header explains each flag.

To change the slowdown, edit the minterpolate rate. `fps=60` gives roughly 2× slow motion instead of 4×. If you change the playback rate, change it in both `setpts` and `-r` so they stay matched. The script drops audio, so add any sound in your editor.

If the output looks wrong or the command fails:

- "Could not find module": set `FREI0R_PATH` as the header shows.
- frei0r isn't recognised at all: your ffmpeg was built without it.
- Rendering is slow: expect this, because minterpolate is slow.
- The file is large: expect this from ProRes.

## frei0r-sobel-edges.sh

This is for when you want only the outlines of a shot, white edges on black, framed as a centered 1024×768 (4:3) window for projection or an LED wall. The header explains each flag. It's the plain version of the edge effect. For edges combined with glitching, use [frei0r-glitch-sobel-baltan.sh](frei0r-glitch-sobel-baltan.sh) or [sobel-edge-glitch.sh](sobel-edge-glitch.sh) instead. To composite a graphic before edge detection, see [../overlay/overlay-then-sobel.sh](../overlay/overlay-then-sobel.sh).

Useful variations:

- Feed it already-processed footage for layered looks, such as the output of [frei0r-nervous-slowmo-prores.sh](frei0r-nervous-slowmo-prores.sh). Change the input file name to match.
- Change the crop size to fit a different screen or wall resolution.
- Change `-r 29.97` to match your playback system.

If ffmpeg reports "Could not find module", set `FREI0R_PATH` as the header shows. If the crop step fails, the input is smaller than 1024×768. Scale it up first or pick a smaller crop. If the frame is mostly black, the source probably lacks contrast, so there are few edges to find.

## normalize-levels.sh

Useful when an image sequence looks flat, washed out or tinted, and you want a quick auto-levels pass while turning it into a 1280×720 preview video. Because normalize works over a rolling window of frames, it adapts as the footage changes. That makes it a poor fit when exposure has already been graded, or when you need levels to stay fixed for the whole clip. The header explains each flag.

Useful variations:

- Set `independence=0` to stretch all channels together and keep the original hues.
- Change `-framerate 29.97` to match how the frames were shot, and change or remove `-t 10` to render more of the sequence.
- Change `+200` in the crop to move the window up or down, or set it to `+0` to center it.

If colors shift dramatically, switch to `independence=0`. If the output is blocky, that's the `-crf 40` draft setting; use `-crf 18` for a final render. If ffmpeg finds no input, check that your files match the `frames/f%05d.jpg` pattern.

## random-difference-glitch.sh

Use this when you want footage dissolved into glowing motion edges on black, slowed and smeared by interpolation: music videos, title backgrounds, abstract loops. It works best on clips with plenty of movement. Skip it when the subject needs to stay recognisable, or when picture and sound must stay in sync. The header explains each flag.

Useful variations:

- Change `-ss 21` to start where the action is.
- Raise or lower `frames=5` to make the shuffle more or less chaotic.
- Edit `1920:1080` in both `scale` and `crop` for other frame sizes.

If the output is mostly black, the source has too little motion. If it looks like crawling noise, `normalize` is stretching tiny frame-to-frame differences to full contrast. The audio is slowed to 0.25× while the video plays about 0.3× speed, so expect the sound to run past the picture. `minterpolate` is slow, so test on a short clip first.

Related: [sobel-edge-glitch.sh](sobel-edge-glitch.sh), [shuffleframes-stutter.sh](shuffleframes-stutter.sh), [normalize-levels.sh](normalize-levels.sh), [../timing/minterpolate-slowmo-with-audio.sh](../timing/minterpolate-slowmo-with-audio.sh).

## shuffleframes-stutter.sh

Use this when you want a hard, rhythmic strobe: the picture keeps snapping back to one anchor frame while the action moves forward underneath it. It works best on footage with clear motion, so the jumps read as a stutter rather than as flicker. It is not the right choice for smooth slow motion or for a gentle loop. The header explains each flag.

Useful variations:

- Shorten the map to `0 1 0 2 … 0 8` for a faster, tighter cycle. The header suggests this.
- Change `-t 10` for a longer or shorter clip, and change `-framerate 29.97` to match your source.
- Switch `-crf 40` to `-crf 18` for a final render.

If the output looks wrong, first check that `frames/f%05d.jpg` matches your actual file names. If the subject is cut off, adjust the `+200` crop offset or the `1280:720` size. If motion seems to skip between cycles, that is the map at work. It has 58 entries but only uses frames 0–29 of each group.

## sobel-edge-glitch.sh

Use this when you want footage turned into a jittery, warped line drawing: dark motion outlines on white, with a stutter that keeps snapping back to the first frame. It works on a numbered JPEG sequence, and the header explains each flag. It is a poor fit if you need audio, since `-an` drops it, or if frei0r isn't installed.

To understand or adapt the look, drop stages from the front of the chain one at a time, as the header suggests. For a step-by-step build of the stutter stage on its own, see [shuffleframes-stutter.sh](shuffleframes-stutter.sh).

Other useful changes:

- Change `1280:720`, the `+200` crop offset, or `-framerate 29.97` to suit your source.
- Raise or lower the distort0r amplitude (`0.02`) for more or less warp.
- Switch `-crf 40` to `-crf 18` for a final render.

If the output looks wrong, check these first:

- **"Could not find module":** set `FREI0R_PATH` as the header describes.
- **Mostly blank white frames:** expected with static footage, because `tblend` keeps only what changed.
- **Blocky output:** that is the draft CRF.
- **Bad framing:** check that the `+200` offset suits your shot.
