# Timing and slow motion

The scripts in this folder change how time plays back: most stretch a clip into slow motion, and a couple change the frame rate without changing the speed. They work in one of two ways: either by playing every frame of high-frame-rate footage at 29.97 fps, or by using ffmpeg's `minterpolate` filter to synthesize in-between frames. Reach for them when you need slow motion from either kind of footage, want to compare interpolation settings to reduce artifacts, or need to turn odd or variable frame rates into a steady 29.97 fps.

## conform-to-2997-prores.sh

Use this when the clip was shot at a high frame rate (60, 120 or 240 fps) and you want smooth slow motion without invented frames. The slowdown is the source rate divided by 29.97, so 240 fps footage becomes roughly 8× slower. The output is an editing intermediate, not a delivery file. The header explains each flag.

Don't use it on 24, 25 or 30 fps footage. There are no extra frames to spread out, so the result plays at about normal speed. For those clips, use [minterpolate-slowmo-prores.sh](minterpolate-slowmo-prores.sh), which synthesizes the in-between frames.

To conform to a different timeline rate, change 29.97 in both `setpts` and `-r`. Keep the two values the same. For smaller files, lower `-profile:v` to 1 (LT) or 0 (Proxy). For more headroom when grading, raise it to 3 (HQ).

If the output isn't slower, check the source's actual frame rate. Some phones label 120 fps clips as 30 fps. The result is silent on purpose; add audio separately in your editor.

## extreme-slowmo-12x.sh

Use this when you need a dramatic 12.5× slowdown of ordinary 30 fps footage and have no high-frame-rate source to work from. It replaces the old butterflow workflow with ffmpeg alone; the header explains each flag. Most frames on screen are synthesized, so it suits smooth, steady motion better than fast or chaotic action. Expect long renders: a 10 s clip becomes 125 s of output.

Skip it if you need sound, because `-an` drops the audio. For that case, look at [minterpolate-slowmo-with-audio.sh](minterpolate-slowmo-with-audio.sh).

To use a different factor or source rate, set `fps` to the source fps ÷ speed. Then replace both 30s, in `setpts` and `-r`, with the source rate. For example, a 24 fps source at 12.5× needs `fps=300`, `setpts=N/(24*TB)` and `-r 24`.

If the output runs longer or shorter than 12.5× the input, check that the source really is 30 fps. Warping or smearing around moving edges comes from the interpolation guessing. Clips with simpler motion hold up better.
