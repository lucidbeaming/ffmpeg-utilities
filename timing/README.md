# Timing and slow motion

The scripts in this folder change how time plays back: most stretch a clip into slow motion, and a couple change the frame rate without changing the speed. They work in one of two ways: either by playing every frame of high-frame-rate footage at 29.97 fps, or by using ffmpeg's `minterpolate` filter to synthesize in-between frames. Reach for them when you need slow motion from either kind of footage, want to compare interpolation settings to reduce artifacts, or need to turn odd or variable frame rates into a steady 29.97 fps.

