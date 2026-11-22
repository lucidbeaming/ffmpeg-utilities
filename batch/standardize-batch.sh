# Enlarge or shrink to 1080p, filling the frame and use baseline codec settings for wide compatibility and web presentation

for i in *.mov;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,format=yuv420p" -filter:a loudnorm -c:v libx264 -crf 21 -preset slow -profile:v baseline -level 3.1 -c:a aac -b:a 128k -ac 1 -ar 44100 -movflags +faststart "${name}".mp4
done
