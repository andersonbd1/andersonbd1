export PATH="/cygdrive/c/Program Files/Streamripper:$PATH"
#echo $PATH
#streamripper -h
dir="F:/backup/My Music/rock/Podcasts/Merriam-Webster's Word of the Day/"
#streamripper 'http://www.radioparadise.com/musiclinks/rp_128.m3u' -s -A -a -d "$outfile" -M 1 -l 3

let lastCrawledHour=5
lastCrawledDay="Fri"
while [ 1 -eq 1 ]
do 
  hour=$(date +%H)
  day=$(date +%a)
  #echo hour: $hour
  #echo day: $day
  if [ $lastCrawledHour -ne $hour ] && [ "$lastCrawledDay" != "$day" ] && [ $hour -eq 7 ]
  then
    let lastCrawledHour=$hour
    lastCrawledDay=$day
    cd /cygdrive/f/backup/My\ Music/rock/Podcasts/Merriam-Webster\'s\ Word\ of\ the\ Day/
    newest_podcast_file=$(ls -t1 * | head -n 1)
    cd ~-
    streamripper 'http://www.radioparadise.com/musiclinks/rp_128.m3u' -s -A -a -d "${dir}" -l 1800
    cd /cygdrive/f/backup/My\ Music/rock/Podcasts/Merriam-Webster\'s\ Word\ of\ the\ Day/
    rm *.cue
    rip_file=$(ls -t1 *.mp3 | head -n 1)
    echo "mv $rip_file $newest_podcast_file"
    mv $rip_file $newest_podcast_file
    cd ~-
  fi
  sleep 1
done
