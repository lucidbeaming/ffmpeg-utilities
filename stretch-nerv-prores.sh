for i in *.MOV;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -vf "frei0r=nervous,minterpolate='fps=120',setpts=N/(29.97*TB)" -an -pix_fmt yuv422p10le -r 29.97 -vendor apl0 -c:v prores -profile:v 2 "out/${name}-nerv-stretch-pro".mov
  ffmpeg -i "${i}" -vf "minterpolate='fps=120',setpts=N/(29.97*TB)" -an -pix_fmt yuv422p10le -r 29.97 -vendor apl0 -c:v prores -profile:v 2 "out/${name}-stretch-pro".mov
done
