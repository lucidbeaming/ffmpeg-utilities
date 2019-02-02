for i in *.mp4;
  do name=`echo "${i%.*}"`;
  echo $name;
	ffmpeg -i "${i}" -filter_complex "scale=720:480:force_original_aspect_ratio=increase,crop=720:480" -an -vcodec libx264 -preset veryslow -crf 24 -pix_fmt yuv420p "${name}"-ntsc.mov
done