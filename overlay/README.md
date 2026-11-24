# Overlays and compositing

These scripts all work on what appears inside the frame. They layer a PNG logo, watermark or mask over a video, tile many clips into one mosaic, or remove a logo or date stamp that was burned into old footage. Each one first scales and crops the video to a fixed frame size, so positions and sizes are predictable, and the header explains each flag. Use them when you need branding on a clip, a grid of many videos at once, or a cleanup pass on camera footage, and change the frame size, the overlay image or the grid dimensions to fit your material.

## center-png-overlay-4x3.sh

Use this when you need a 4:3, 640×480 silent clip with a graphic or mask stamped in the middle, for example a circular vignette PNG over footage of any shape. For square output, use [center-png-overlay-square.sh](center-png-overlay-square.sh). For the same fill-and-crop without an overlay, see [../resize-crop/fill-crop-640x480.sh](../resize-crop/fill-crop-640x480.sh). The header explains each flag.

Skip it if you need the soundtrack, since the audio is dropped. Also skip it if the whole source frame must stay visible: widescreen input loses its left and right edges to fill 4:3.

To change the frame size, edit `640:480` in both the `scale` and `crop` parts. Raise the `-crf` value for a smaller file, or lower it for better quality.

If the output looks wrong:

- **The graphic is clipped or off-center.** The PNG isn't resized, so make it 640×480 or smaller.
- **A solid block covers the picture.** The PNG has no transparency.
- **Subjects are cut off at the sides.** That's the crop. Reframe the source first.

## center-png-overlay-square.sh

Use this when you need a square clip with a logo or watermark sitting exactly in the middle. It fills a 720×720 frame from the video, cropping whatever doesn't fit, and lays the PNG over it at the PNG's own size. The header explains each flag.

Don't use it if you need to keep the whole frame, because wider or taller footage loses its edges to the crop. For 4:3 output, use [center-png-overlay-4x3.sh](center-png-overlay-4x3.sh). To take a logo out rather than add one, see [remove-logo-delogo.sh](remove-logo-delogo.sh).

Variations:

- **Different size:** change all four 720s together.
- **Light and dark versions:** run it twice, once with a white PNG and once with a black one, using a different output name each time.
- **Video already the right size:** the header's minimal form skips the scale and crop.

If the output looks wrong, check the PNG first. The logo isn't scaled, so one larger than 720×720 runs off the edges. A PNG without transparency shows up as a solid box.

## overlay-then-sobel.sh

Use this when you want the logo and the footage to read as one line drawing. The PNG is centered in a 1024×768 frame and then the whole composite is edge-detected, so the logo becomes an outline like everything else. The header explains each step.

Don't use it if the logo must stay solid and legible. Swap the order as the header describes, with Sobel on `[0:v]` first and then the overlay, to keep a clean logo on top of edge-detected footage. For a plain centered logo with no effect, use [center-png-overlay-4x3.sh](center-png-overlay-4x3.sh). For edges without a logo, see [../effects/frei0r-sobel-edges.sh](../effects/frei0r-sobel-edges.sh).

To change the frame size, edit `1024:768` in both the scale and the crop so they match.

If the output looks wrong:

- **"Could not find module":** set `FREI0R_PATH` as shown in the header. With Homebrew on Apple Silicon, that's `/opt/homebrew/lib/frei0r-1`.
- **Parts of the picture are missing:** the scale-then-crop fills the frame and trims the overflow. Sources that aren't 4:3 lose their sides, or their top and bottom.
- **The logo is only an outline:** that's the intended look. Swap the filter order to keep it solid.

## remove-logo-delogo.sh

Use this when old camera footage has a burned-in logo or date stamp in a fixed spot and a soft blur is better than the mark. delogo doesn't recover what was under the logo. It fills the rectangle from the surrounding pixels, so the patch looks clean on sky or walls and like a smudge on detailed footage. It won't follow a mark that moves, because the box is fixed for the whole clip. The header explains each flag.

To adapt it:

- Set the delogo box for your footage. Grab a frame with `../stills-and-gifs/extract-frame-jpg.sh` and measure it, or add `:show=1` to see the box.
- Drop `-ss 15` and `-t 10` once the test clip looks right.
- For a different target rate, change 29.97 in all three places.

If the patch misses the logo, make sure you measured on a 1920×1080 frame. The box is in output coordinates, after the scale and crop, so values measured on the original frame need converting. Warping or ghosting around fast motion comes from minterpolate, not delogo.

## video-mosaic-grid.sh

Use this when you want a wall of clips playing side by side, such as a contact sheet of takes or a visual overview of a folder of footage. Run it inside a folder of `.mp4` files. It uses the first COLS×ROWS clips in name order and ignores the rest. The header explains each flag.

Look elsewhere if your clips have no audio track. `amix` fails on silent inputs, so you'd need to drop the audio part and `-map "[a]"` as the header describes. Also skip it if you need the full length of every clip, because `-shortest` cuts the whole mosaic at the shortest one.

For fewer clips, set `COLS=4 ROWS=4`, or change `TILE_W`/`TILE_H`. The output frame is COLS×TILE_W by ROWS×TILE_H, so keep both totals even for `yuv420p`.

If the output looks wrong, check these:

- **Audio is distorted or far too loud:** remove `normalize=0`.
- **Some tiles are black:** the folder had fewer clips than grid cells.
- **Edges of shots are cut off:** that's expected. Each clip is cropped to fill its tile.
- **The video ends early:** one clip is shorter than the rest.
