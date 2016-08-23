tmp_dir=/mydev/andersonbd1/tmp
source_dir="/myaudio/spoken/DR-Bible/masterDRVnt/06.\ Romans-complete"
boost=8
drop_dir=/mydropbox/bookmobile
file_type=mp3

rm $tmp_dir/*
echo cd $source_dir
eval cd $source_dir
for file in $(ls *.${file_type})
do
  sox -v $boost $file -r 24k -c 1 $tmp_dir/$file
done

cd $tmp_dir
zip $drop_dir/tmp.zip *.${file_type}

#C:\Users\banderso>start wmplayer "d:\audio\spoken\DR-Bible\masterDRVnt\06. Romans-complete\DR-RomansChapter01.mp3"
#C:\Users\banderso>start wmplayer "d:\dev\andersonbd1\tmp\DR-RomansChapter01.mp3"
