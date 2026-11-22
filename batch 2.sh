for i in *.mp4; do
	ffmpeg -i "$i" -vf "scale=640:480:force_original_aspect_ratio=increase,crop=640:480,fps=fps=30" -c:a aac -b:a 128k -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p "out/$i"
done
say -v Alex "Process complete"
