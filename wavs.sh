for i in *.aiff;
  do name=`echo "${i%.*}"`;
  echo $name;
  ffmpeg -i "${i}" -r 30 -filter_complex "[0:a]showwaves=mode=cline:scale=lin:colors=White|White:size=1920x1080:rate=30,format=yuv422p[v]" -map "[v]" -map 0:a -c:v prores -profile:v 3 "${name}"-wavs1.mov
  ffmpeg -i "${i}" -r 30 -filter_complex "[0:a]showwaves=mode=cline:scale=log:colors=White|White:size=1920x1080:rate=30,format=yuv422p[v]" -map "[v]" -map 0:a -c:v prores -profile:v 3 "${name}"-wavs2.mov
  ffmpeg -i "${i}" -r 30 -filter_complex "[0:a]showwaves=mode=p2p:scale=lin:colors=White|Gray:size=1920x1080:rate=30,format=yuv422p[v]" -map "[v]" -map 0:a -c:v prores -profile:v 3 "${name}"-wavs3.mov
  ffmpeg -i "${i}" -r 30 -filter_complex "[0:a]showwaves=mode=point:split_channels=1:scale=log:colors=White|White:size=1920x1080:rate=30,format=yuv422p[v]" -map "[v]" -map 0:a -c:v prores -profile:v 3 "${name}"-wavs4.mov
done
