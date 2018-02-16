test=0
#test=1

boost=2
album="Genesis"

tmp_dir=~/dev/andersonbd1/tmp
mkdir $tmp_dir 2> /dev/null
rm $tmp_dir/*
#drop_dir=/mydropbox/bookmobile
drop_dir=~/Dropbox/bookmobile
file_type=mp3

# to find what you want
# $ find /mydev/audio/spoken/DR-Bible/ -type d | grep -v MAC | grep -i mach
i=0
IFS=$(echo -en "\n\b");
#for source_dir in $( echo -e "/mydev/audio/spoken/DR-Bible/masterDRVnt/02.\ Mark-complete\n/mydev/audio/spoken/DR-Bible/DROTMP3fix/45-1\ Machabees\n/mydev/audio/spoken/DR-Bible/DROTMP3fix/46-2\ Machabees")
cd ~/Google\ Drive\ File\ Stream/My\ Drive/audio
for source_dir in $( echo -e "01-Genesis")
do
  if [ $test = 0 ]; then
    echo 'not a test'
  fi
  echo cd "$source_dir"
  eval cd "$source_dir"
  for file in $(ls *.${file_type})
  do
    echo "sox -v $boost $file -r 24k -c 1 $tmp_dir/$file"
    ((i = i + 1))
    echo "$i"
    if [ $test = 0 ]; then
      sox -v $boost $file -r 24k -c 1 $tmp_dir/$file
      id3tag -2 -t${i} -A${album} $tmp_dir/$file
    fi
    #ls $file
    #cp $file $tmp_dir/${i}-${file}
  done
done

cd $tmp_dir
pwd

if [ $test = 0 ]; then
  rm $drop_dir/tmp.zip
  zip $drop_dir/tmp.zip *.${file_type}
fi

#C:\Users\banderso>start wmplayer "d:\audio\spoken\DR-Bible\masterDRVnt\06. Romans-complete\DR-RomansChapter01.mp3"
#C:\Users\banderso>start wmplayer "d:\dev\andersonbd1\tmp\DR-RomansChapter01.mp3"
