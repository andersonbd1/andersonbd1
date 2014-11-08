# content lines 53-2013
# total lines 2540
# 2540 - 53 = 


for d in $(ls -1d *)
do
  if [ -d ${d} ]
  then
    #echo $d
    . ./${d}/meta.sh

    input_file=${d}/${d}.html
    total_lines=$(wc -l "${input_file}" | gawk '{print $1}')
    tail_n=$(echo "${total_lines} - ${content_start}" | bc)
    head_n=$(echo "${content_end} - ${content_start}" | bc)

    #echo "total_lines: $total_lines"
    #echo "content_start: $content_start"
    #echo "input_file: $input_file"
    #echo "content_end: $content_end"
    #echo "tail_n: $tail_n"
    #echo "head_n: $head_n"

    #tail -n $tail_n ${input_file} | head -n $head_n | sed 's/^<.*//g' > ${d}.txt
    tail -n $tail_n ${input_file} | head -n $head_n | perl -pe 's/<[\/]?.*?>/ /g' | sed 's/&quot;//g' > ${d}/${d}.txt
    cat ${input_file} | perl -pe 's/<[\/]?.*?>/ /g' | sed 's/&quot;//g' > ${d}/${d}.txt2

    wc -w ${d}/${d}.txt
    #wc -w ${d}/${d}.txt2
  fi
done
