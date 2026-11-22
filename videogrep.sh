videogrep --input *.mp4 -tr

videogrep --input *.mp4 -tr -mo /Volumes/berlin/video/supercuts/vosk-big

cat *.txt | tr -s ' ' '\n' | sort | uniq -c | sort -r | awk '{ print $2, $1 }' | sed '/^[0-9]/d' > words.jjc

videogrep -i *.mp4 -o job.mp4 -t -p 25 -r -s 'job' -st word

ffmpeg -i emot-stretch.mp4 -c:v mpeg4 -vtag xvid emot-avi.avi

ffmpeg -i emot-avi.avi -r 30 0c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast emot-crush.mp4


for i in *.mp4; do
	ffmpeg -i "$i" -vf "scale=640:480:force_original_aspect_ratio=increase,crop=640:480fps=fps=30" -c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p "v-$i"
done
say -v Alex "Process complete"


ffmpeg -i noise.mp4 -filter:v "minterpolate='fps=120',setpts=N/(29.97*TB)" -filter:a "atempo=.5,atempo=.5" -c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast noistretch-m.mp4

ffmpeg -i dsa.mp4 -filter:v "minterpolate='fps=120:scd=none',setpts=N/(29.97*TB),scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080" -filter:a "atempo=.5,atempo=.5" -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast dsa-m.mp4

ffmpeg -i time.mp4 -filter:v "minterpolate='fps=120:scd=none',setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" -filter:a "atempo=.5,atempo=.5" -r 29.97 -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast bigtime.mp4

ffmpeg -i emotion.mp4 -filter:v "minterpolate='fps=60:scd=none',setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" -filter:a "atempo=.5" -r 30 -c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast emot-stretch.mp4

ffmpeg -i fealin.mp4 -filter_complex "frei0r=nervous,minterpolate='fps=60:scd=none',setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" -filter:a "atempo=.5" -r 30 -c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p emot-stretch.mp4

ffmpeg -i grand-out.mp4 -filter_complex "frei0r=nervous,minterpolate='fps=120:scd=none',setpts=N/(29.97*TB),scale=640:480:force_original_aspect_ratio=increase,crop=640:480" -filter:a "atempo=.5,atempo=.5" -r 29.97 -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p grand-out-stretch.mp4

ffmpeg -i if.mp4 -filter_complex "frei0r=nervous,minterpolate='fps=120:scd=none',setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:480" -filter:a "atempo=.5,atempo=.5" -r 29.97 -c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p if-stretch-big.mp4

ffmpeg -i hrdst.mp4 -filter_complex "crop=640:480,minterpolate='fps=29.97:scd=none',setpts=N/(29.97*TB)" -r 29.97 -c:a aac -b:a 128k -c:v libx264 -crf 21 -preset veryfast -pix_fmt yuv420p hrdstnorm.mp4

ffmpeg -ss 21 -i feart-ant.mp4 -filter_complex "random=frames=5,tblend=all_mode=difference,normalize=blackpt=black:whitept=white:smoothing=0,minterpolate='fps=100:scd=none',setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,unsharp" -filter:a "atempo=.5,atempo=.5" -r 29.97 -c:a aac -b:a 128k -c:v libx264 -crf 21 -pix_fmt yuv420p -preset veryfast feart-ant-stretch2.mp4

ffmpeg -i stranger-cut.mp4 -filter:v "frei0r=nervous,minterpolate='fps=120:scd=none',setpts=N/(29.97*TB),setpts=N/(29.97*TB),scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" -filter:a "atempo=.5,atempo=.5" -r 29.97 -c:a aac -b:a 128k -c:v libx264 -crf 20 -preset veryfast even-stranger.mp4
