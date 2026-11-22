for i in *.mp4; do
	ffmpeg -ss 60 -t 7.9 -i "$i" -vf "transpose=2,scale=414:736,fps=fps=30" -an -map_metadata 0 -metadata:s:v rotate="90" -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p "spotify/$i"
done
say -v Alex "Process complete"
