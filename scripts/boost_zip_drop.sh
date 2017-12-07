tmp_dir=/mydev/andersonbd1/tmp
mkdir $tmp_dir 2> /dev/null
rm $tmp_dir/*

boost=2
#drop_dir=/mydropbox/bookmobile
drop_dir=/windows_users/banderso/Dropbox/bookmobile
file_type=mp3

# to find what you want
# $ find /mydev/audio/spoken/DR-Bible/ -type d | grep -v MAC | grep -i mach
i=0
IFS=$(echo -en "\n\b");
#for source_dir in $( echo -e "/mydev/audio/spoken/DR-Bible/masterDRVnt/02.\ Mark-complete\n/mydev/audio/spoken/DR-Bible/DROTMP3fix/45-1\ Machabees\n/mydev/audio/spoken/DR-Bible/DROTMP3fix/46-2\ Machabees")
for source_dir in $( echo -e "/mydev/audio/spoken/DR-Bible/masterDRVnt/" )
do
  echo "$i"
  ((i = i + 1))
  echo cd "$source_dir"
  eval cd "$source_dir"
  for file in $(ls *.${file_type})
  do
    echo "sox -v $boost $file -r 24k -c 1 $tmp_dir/$file"
    sox -v $boost $file -r 24k -c 1 $tmp_dir/$file
    #cp $file $tmp_dir/${i}-${file}
  done
done

cd $tmp_dir
pwd

rm $drop_dir/tmp.zip
zip $drop_dir/tmp.zip *.${file_type}

#C:\Users\banderso>start wmplayer "d:\audio\spoken\DR-Bible\masterDRVnt\06. Romans-complete\DR-RomansChapter01.mp3"
#C:\Users\banderso>start wmplayer "d:\dev\andersonbd1\tmp\DR-RomansChapter01.mp3"
