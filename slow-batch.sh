for i in *.MP4;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -vf "setpts=N/(29.97*TB)" -r 29.97 -c:v prores_ks -profile:v 2 -vendor apl0 -pix_fmt yuv422p10le "${name}".mov
done