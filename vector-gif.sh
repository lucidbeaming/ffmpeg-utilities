for i in *.mp4;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -vf palettegen "${name}".png
  ffmpeg -ss 5 -i "${i}" -i "${name}".png -filter_complex paletteuse -t 20 -r 0.5 "out/${name}".gif -hide_banner
done
