for i in *.MP4;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -i lucidwhite.png -filter_complex "scale=720:720:force_original_aspect_ratio=increase,crop=720:720,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -acodec copy -vcodec libx264 -preset slow -crf 17 -pix_fmt yuv420p -movflags faststart "out/${name}-w".mp4
  ffmpeg -i "${i}" -i lucidblack.png -filter_complex "scale=720:720:force_original_aspect_ratio=increase,crop=720:720,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -acodec copy -vcodec libx264 -preset slow -crf 17 -pix_fmt yuv420p -movflags faststart "out/${name}-b".mp4
done
