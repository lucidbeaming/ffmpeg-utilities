# Stills and GIFs

The scripts in this folder turn a video into still images: a single JPEG frame for a `<video>` poster or thumbnail, or a GIF built with its own 256-color palette. Reach for them when you need a lightweight preview of a clip rather than another video encode. To adapt one, change the seek time, size or frame rate in the command; the header explains each flag.

## extract-frame-jpg.sh

Use this when you need one still from a video: a `<video>` poster, a thumbnail, or a quick reference frame. It pairs naturally with the 600×600 encode in [`../conversion/web-mp4-square-600.sh`](../conversion/web-mp4-square-600.sh), so the poster matches the player size. The header explains each flag.

Don't use it for an animated preview; [`palette-gif.sh`](palette-gif.sh) covers that. It also isn't the right tool for non-square footage as written, because `scale=600:600` stretches anything that isn't already square.

Common edits:

- Change `-ss 7` to the moment you want, for example a frame after a title card.
- Change `600:600` to a size that matches your source's aspect ratio, or crop to square first with one of the [`../resize-crop/`](../resize-crop/fill-crop-640x480.sh) scripts.
- Raise `-q:v` toward 31 for smaller, lower-quality files.

If faces or shapes look squashed, the source isn't square; fix the scale size. If the JPEG looks blocky, check that `-q:v` is still 2. If you're adapting an older copy that used `-t 1 -f image2`, switch to `-frames:v 1` as described in the header.
