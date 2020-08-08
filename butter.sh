for m in *.MOV; do
butterflow -s a=0,b=end,spd=0.08 "$m" --poly-s 2 -ff box -l -v -o "collect/${m%.*}.mp4"
done
