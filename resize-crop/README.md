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
