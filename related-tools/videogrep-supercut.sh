#!/usr/bin/env bash
# Transcribe videos and cut a supercut of every time a word is spoken
#
# videogrep (https://github.com/antiboredom/videogrep) searches subtitle or
# transcript timestamps and joins the matching moments into one video: a
# "supercut". It can transcribe speech itself with Vosk (an offline speech
# recognizer), so no subtitle files are needed. The ffmpeg examples in
# timing/ and effects/ (slow motion, nervous jitter, Xvid crush) were used
# to process these supercuts further.
#
# Install: pip install videogrep
#
#   --input / -i           one or more video files
#   --transcribe / -tr     transcribe with Vosk, writing a .json transcript
#                          next to each video (reused on later runs)
#   --model / -mo          a Vosk model folder (e.g. a large English model
#                          from alphacephei.com/vosk/models) for better
#                          accuracy than the bundled small one
#   --ngrams / -n 1        list the most common words across the transcripts
#   --search / -s          the word or phrase to find
#   --search-type / -st    sentence (default), fragment (word-level
#                          timestamps, for single words) or mash
#   --padding / -p         seconds to add before and after each clip
#   --randomize / -r       shuffle the clips
#   --output / -o          the supercut file
#
# Source:  ffmpeg-utilities/videogrep.sh
# Changed: -st word → --search-type fragment (current videogrep accepts
#          only sentence, fragment or mash); -p 25 → --padding 0.25 (-p is in
#          seconds, so 25 would add 25 s around each word); removed -t, which
#          is no longer an option; the word-count pipeline over *.txt became
#          --ngrams 1, since transcripts are now .json. The Vosk model path
#          is a placeholder.
# Not tested here: videogrep is a separate install and needs speech to
#          transcribe.

# Transcribe every video in the folder
videogrep --input *.mp4 --transcribe

# Same, with a larger downloaded Vosk model
videogrep --input *.mp4 --transcribe --model /path/to/vosk-model

# The most frequent words, to choose what to search for
videogrep --input *.mp4 --ngrams 1

# Supercut of every "job", shuffled, with a quarter second of padding
videogrep --input *.mp4 --search 'job' --search-type fragment \
  --padding 0.25 --randomize --output job.mp4
