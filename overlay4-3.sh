for i in *.mp4;
  do name=`echo "${i%.*}"`;
  echo $name;
	ffmpeg -i "${i}" -i large-circle-50.png -filter_complex "scale=640:480:force_original_aspect_ratio=increase,crop=640:480,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -an -vcodec libx264 -preset veryslow -crf 24 -pix_fmt yuv420p "${name}"-ntsc.mov
done