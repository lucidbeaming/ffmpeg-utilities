# Image sequences

The scripts in this folder turn a folder of numbered still images into a video. Each one reads the frames at a set rate, scales them to cover a fixed frame size such as 1080p or 720p, and crops off whatever overflows. Reach for them when you have camera timelapse photos, rendered or exported frames to assemble, or vector animation frames that need to become a transparent overlay. Adapting one usually means matching the filename pattern and start number to your files and adjusting the rate and output size; each script's header explains every flag.

## gopro-timelapse-start-number.sh

Use this when a camera has numbered your timelapse photos from somewhere other than zero or one, as GoPro does, and you want a 1080p video without renaming anything. The header explains each flag. If your photos already start near 0 or 1, or you want a slower slideshow pace, [image-sequence-2-video.sh](image-sequence-2-video.sh) is the simpler starting point.

To adapt it:

- Set `-start_number` to the number on your first photo, and edit `G00%05d.JPG` to match your camera's file names, including the upper-case extension.
- Lower `-framerate` for a slower timelapse, or raise it for a faster one.
- Change both `1920:1080` values together for a different output size.

If ffmpeg reports that it can't find the input, the start number or the pattern doesn't match the first file. If the video ends early, look for a missing number in the sequence. If the top and bottom of the frame are missing, that's expected: the 4:3 photos are cropped to fill 16:9.

## image-sequence-2-video.sh

Reach for this when you have a folder of numbered stills, such as a GoPro timelapse, and want a 1080p MP4 that fills the frame with no black bars. The header explains each flag. Skip it if the whole image must stay visible: the fill-and-crop step trims the edges of any image that isn't 16:9, keeping the centre.

Each image is shown at 3 per second and the output is written at 29.97 fps, so stills repeat rather than blend. Raise the input rate for a faster timelapse or lower it to linger. Other easy edits:

- set the start number to your first file and the name pattern to match your camera's naming
- change 1920:1080 in both places for another frame size
- raise the CRF value for smaller files, or lower it for higher quality

If the output looks wrong, first check that the start number matches a real file. Then make sure there are no gaps in the numbering, since a missing number can end the sequence early. Also check that the digit count in the pattern matches your filenames. If the framing is off, your source isn't 16:9 and the crop removed more than you expected.

## images-to-video-offset-crop.sh

Use this when you have a folder of numbered stills, especially portraits, and want a 1280×720 video framed a little low, so that heads keep their chins rather than their foreheads. It is the starting point the `effects/` chains assume. The header explains each flag.

Skip it for footage that is already 16:9. Those frames scale to exactly 720 px tall, so there is nothing to shift and the 200 px offset does nothing.

Useful edits:

- Change `+200` to move the framing, or delete it for a plain centered crop.
- Change `1280:720` in both filters for another size. Keep both numbers even.
- Swap in the source's `-preset ultrafast -crf 40` for quick drafts.

If the framing looks wrong, check how tall the scaled stills are. When the extra height is less than 400 px, the crop gets clamped to the bottom edge. If frames are missing, check that the files match `f%05d.jpg` exactly. Numbering that doesn't start at 1 is covered in [gopro-timelapse-start-number.sh](gopro-timelapse-start-number.sh).

## svg-frames-to-prores4444-alpha.sh

Use this when an overlay exists as numbered SVG frames, from [primitive](../related-tools/primitive-png-to-svg.sh) or a vector tool, and an editor needs it as a movie with real transparency. If you don't need alpha, ProRes 4444 makes very large files for no benefit. The header explains each flag.

Common changes:

- Set `-framerate 15` to the rate the animation was drawn at, and `-r 29.97` to your project's rate.
- Change `1920:1080` in both the scale and the crop to match your timeline.
- Raise `-density 96` if frames look soft after scaling up.
- With an ffmpeg built with librsvg, skip the ImageMagick loop and read `%05d.svg` directly.

If the background comes out black or opaque, open a few files in `png/` and check that they are transparent. If ffmpeg finds no input, check that the SVGs are named `00001.svg`, `00002.svg` and so on. If edges are missing, your frames aren't 16:9. The crop fills the frame by trimming whatever overhangs.
