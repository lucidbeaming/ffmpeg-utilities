for i in *.MOV;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -c:v copy -c:a copy -movflags faststart "f ${name}".mp4
done
