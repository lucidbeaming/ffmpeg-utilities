for i in *.mov;
  do name=`echo "${i%.*}"`;
  ffmpeg -i "${i}" -vf "scale=1728:1080:force_original_aspect_ratio=increase,crop=1434:1080:147:0" -r 29.97 -an -c:v libx264 -crf 18 -pix_fmt yuv420p -preset ultrafast "out/${name}".mp4
done

