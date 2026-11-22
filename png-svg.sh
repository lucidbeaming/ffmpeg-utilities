for i in *.png;
  do name=`echo "${i%.*}"`;
  echo $name;
  primitive -i "${i}" -o svg/t/"${name}".svg -m 1 -n 150
  # primitive -i "${i}" -o svg/l/"${name}".svg -m 6 -n 300
done

