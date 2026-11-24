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

## minterpolate-mode-comparison.sh

Reach for this when a minterpolate slow-motion render shows warping, ghosting or blocky edges and you want to see which motion-estimation setting copes best with your particular footage. It renders the same 15 seconds eight ways, each about 45 seconds long at 3× slower, so you can compare them side by side. The header explains each setting. Don't use it for final output. It drops audio and encodes with a fast x264 preset, so it's meant only for judging. Once you've chosen, carry that option string over to [minterpolate-slowmo-prores.sh](minterpolate-slowmo-prores.sh) or [minterpolate-slowmo-with-audio.sh](minterpolate-slowmo-with-audio.sh).

Useful variations:

- Move `-ss 5 -t 15` to the section with the hardest motion. A shorter `-t` speeds up the slow settings such as `esa` and `mbsize`.
- Change `fps=90` together with `29.97` to test a different slowdown factor.
- Delete entries from `settings` to rerun only the candidates you're still considering.

If all eight files look identical, the chosen section probably contains little motion. If the files come out short or empty, check that `input.mp4` runs past 0:20.

## minterpolate-normalize-fps.sh

Reach for this when a clip has an odd or variable frame rate (screen recordings, web video, phone clips) and you need a steady 29.97 fps file that plays at its original speed. Instead of dropping or repeating frames, it synthesizes new ones, so motion stays smooth. The header explains each flag.

Skip it if you want slow motion. Use [minterpolate-slowmo-with-audio.sh](minterpolate-slowmo-with-audio.sh) instead. Interpolation is slow to render, so it is also overkill for footage that already has a clean, constant rate.

Variations:

- Change the target rate by editing 29.97 in all three places (minterpolate, setpts, `-r`) so they agree.
- Change the crop size (640:480), keeping it no larger than the input.
- Raise or lower `-crf 21` to trade file size for quality.

If the output looks wrong, check these:

An error at the crop step usually means the input is smaller than 640×480. Warped frames around fast motion come from interpolation. Smeared frames at hard cuts happen because scene-change detection is off (`scd=none`), so cuts get blended. To see how interpolation choices compare, try [minterpolate-mode-comparison.sh](minterpolate-mode-comparison.sh).
