for i in *.mp4;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -vf "scale=600:600,format=yuv420p" -filter:a loudnorm -c:v libx264 -crf 20 -profile:v baseline -level 3.1 -c:a aac -b:a 128k -ac 1 -ar 44100 -movflags +faststart "out/${name}".mp4
  ffmpeg -i "${i}" -codec:v libtheora -qscale:v 5 -vf scale=600:600 -filter:a loudnorm -codec:a libvorbis -qscale:a 4 -ar 44100 "out/${name}".ogv
  ffmpeg -ss 7 -i "${i}" -t 1 -s 600x600 -f image2 "out/${name}".jpg
done
