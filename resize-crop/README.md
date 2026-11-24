# Resize and crop

The scripts in this folder fit existing footage into a fixed output frame: most scale the source until it covers the target size and then crop the overflow, while the vertical Canvas script rotates landscape footage on its side and scales it to a 9:16 portrait frame. Reach for them when a player, projector, monitor or platform expects an exact resolution and you'd rather lose the edges of the picture than add black bars. Each re-encodes to widely compatible H.264, and the target size, frame rate and crop position are plain numbers in the command, so adapting one to another resolution is usually a matter of editing those values; the header explains each flag.

## fill-crop-640x480.sh

Use this when every clip has to land at exactly 640×480 with no black bars and no stretching: a 4:3 slot in a grid, a batch of mixed sources headed for one sequence, or footage for an older 4:3 target. It works like CSS `object-fit: cover`, and the header explains each flag.

Don't use it when the whole picture must stay visible. Wide sources lose their left and right edges, and portrait phone footage loses much of its top and bottom.

For widescreen output, change both the scale and the crop sizes to 1280:720, the variant noted in the header. You can also change `fps=30` to match your project rate. For a 720×480 frame, see [fill-crop-720x480.sh](fill-crop-720x480.sh).

If the output looks wrong:

- The subject is cut off: the crop is always centered, so off-center action is lost.
- Motion stutters: the source rate didn't divide evenly into 30 fps, so frames were dropped or repeated.
- You get a filter error: check the commas between the filters. The original batch loop broke because of a missing comma.

## fill-crop-720x480.sh

Use this when you need a silent clip that exactly fills a 720×480 frame, whatever the source's shape, with no letterbox bars. It works the same way as [fill-crop-640x480.sh](fill-crop-640x480.sh), just at the NTSC raster. The header explains each flag.

Don't reach for it when the edges of the picture matter. Anything outside the centered 720×480 window is cut away, and a wide source loses a lot from its sides. It also isn't a DVD or DV encoder as written, because the pixels stay square and the audio is dropped.

Useful edits:

- For true NTSC DV/DVD output, add `setsar=10/11` or use `-target ntsc-dvd`, as the header notes.
- For a different frame size, change both numbers in `scale` and in `crop` together.
- Raise or lower `-crf 24` to trade file size for quality.

If the output looks wrong, check these first. Stretched or squeezed playback usually points to the sample aspect ratio. Heads or titles cut off means the subject wasn't centered in the source.

## scale-offset-crop-1434x1080.sh

Use this script to turn 1080p widescreen footage into a near-4:3 frame at full 1080 height, for 4:3 projectors or monitors. You can also place the window off-centre by editing the x offset. The header explains each flag. Audio is dropped, so it suits picture-only material. If you want a standard-definition 4:3 file, use [fill-crop-640x480.sh](fill-crop-640x480.sh) or [fill-crop-720x480.sh](fill-crop-720x480.sh) instead.

Useful variations:

- Change the crop's x value (147) to slide the window left or right. Raising it moves the window right.
- Change `-r 29.97` to match a different target frame rate.
- Change `input.mov` and `output.mp4` to your own file names.

If the framing looks off, check the source's shape. The `increase` option scales to *at least* 1728×1080, keeping the aspect ratio. A 16:10 source comes out at exactly 1728×1080, so x=147 centres the window. A 16:9 1920×1080 source stays 1920 wide, so x=147 sits 96 px left of centre. For 16:9 sources, use x=243 to centre the window.

## vertical-canvas-414x736.sh

Use this when you need a short, silent, vertical loop from landscape footage, such as a Spotify Canvas–style clip. It rotates the whole picture a quarter turn instead of cropping it. That suits footage shot with the camera on its side, or a deliberately sideways look. It won't cut an upright portrait out of a normal landscape scene. The header explains each flag.

Easy adaptations:

- Change `-ss 60` and `-t 7.9` to take a different stretch of the source.
- Use `transpose=1` to rotate clockwise instead.
- Change `fps=30` or the `414:736` size to suit the destination.

If the picture comes out upside down from what you expected, switch between `transpose=2` and `transpose=1`. If it comes out sideways and the source already played as portrait, ffmpeg probably auto-rotated it from a rotation flag, so the source didn't need this script. Squashed or stretched output means the source isn't 16:9, because `scale` forces the exact size. A short or empty file means the source runs shorter than about 1:08.
