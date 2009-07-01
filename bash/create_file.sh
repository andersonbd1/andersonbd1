rm ${1} 2> /dev/null
let i=0
#let size=$2*1000
let size=$2
kilo=""
while [ "$i" -lt "1024" ]
do
  kilo="${kilo} "
  let i=$i+1
done
echo $size
let i=0
while [ "$i" -lt "$size" ]
do
  #echo $i
  echo -n "${kilo}" >> ${1}
  let i=$i+1
done
ls -ladh $1
