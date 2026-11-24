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
