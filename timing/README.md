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

## minterpolate-raise-fps.sh

Reach for this when you want 30 fps footage to play back as smooth 120 fps motion at its original speed. Typical uses are a high-frame-rate edit, or a clean look at how well interpolation holds up on your material. The header explains each flag. Skip it when you want the clip slowed down: use [minterpolate-slowmo-prores.sh](minterpolate-slowmo-prores.sh) instead. Also skip it when the "smooth motion" TV look would be unwelcome, such as on footage meant to feel filmic.

The main variation is the target rate. Change `fps=120` to `60` for a lighter file and a faster render, and change `input.mov` and `output.mp4` to suit. To compare interpolation approaches side by side, see [minterpolate-mode-comparison.sh](minterpolate-mode-comparison.sh).

If the output looks wrong:

- Warping or smearing around fast-moving or overlapping objects is typical of synthesized frames. Try a cleaner source, or accept a lower target rate.
- No sound is expected, because the script drops audio.
- If motion doesn't look smoother, your player or display may not show 120 fps. Check the file's frame rate rather than trusting playback.
- Very slow renders are normal for this filter.

## minterpolate-slowmo-prores.sh

Reach for this when you have ordinary ~30 fps footage and want a smooth 4× slowdown without the stutter of repeated frames. It writes ProRes 422, so the result is ready to bring into an editor. The header explains each flag.

Skip it when the shot is full of fast or crossing motion and you need clean frames. Interpolation will warp those areas, and that is part of the look rather than a bug. Also skip it when you need sound: this version drops audio, so use [minterpolate-slowmo-with-audio.sh](minterpolate-slowmo-with-audio.sh) instead. For much stronger slowdowns, see [extreme-slowmo-12x.sh](extreme-slowmo-12x.sh).

To change the slowdown, set `fps` to the source rate times the factor:

- `fps=60` gives 2× from 30 fps footage.
- `fps=240` gives 8× from 30 fps footage.
- `fps=100` gives 4× from 25 fps footage.

Leave the 29.97 values alone. They set the playback rate, not the slowdown.

If the result isn't about four times the source duration, the source probably isn't ~30 fps, so recompute `fps`. If the motion looks odd, compare interpolation modes with [minterpolate-mode-comparison.sh](minterpolate-mode-comparison.sh). Expect slow renders and large files.

## minterpolate-slowmo-with-audio.sh

Use this when you want a short clip slowed to a dreamy 4× with its sound slowed to match, cropped square for a social feed. Scene-change detection is off, so cuts blend into each other. If you want clean cuts, this is the wrong script. If you need an editing intermediate rather than a finished upload, look at [minterpolate-slowmo-prores.sh](minterpolate-slowmo-prores.sh). The header explains each flag.

Useful variations, both from the source:

- For a 16:9 frame, change the scale and crop sizes from `1080:1080` to `1920:1080`.
- For a 2× slowdown, set `fps=60` and use a single `atempo=0.5`.

If you change the slowdown, keep the audio factor equal to the video factor, or the audio will drift out of sync.

If moving edges warp or smear, that comes from interpolation. [minterpolate-mode-comparison.sh](minterpolate-mode-comparison.sh) helps you compare approaches. If the subject gets cut off, the square crop is trimming the sides, so try the 1920×1080 variant. Expect slow encodes, because minterpolate is the costly step.
