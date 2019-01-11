for i in *.aiff;
  do name=`echo "${i%.*}"`;
  echo $name;
   ffmpeg -i "${i}" -r 30 -filter_complex "[0:a]avectorscope=draw=dot:zoom=2:scale=log:size=1920x1080,format=yuv422p[v]" -map "[v]" -map 0:a -c:v prores -profile:v 3 "${name}"-vctr.mov
done
