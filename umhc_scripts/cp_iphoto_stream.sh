#find /windows_users/Ben\ Anderson/Pictures/iCloud\ Photos/  -printf '"%h/%f"\n'| grep -i jpg | xargs ls -ladt --time-style=+"%Y %m %d "  | gawk '{print $6 " " $7 " " $9}' | xargs -l bash -c 'mkdir -p /windows_e/pics/My\ Pictures/$0/$1-iphone 2> /dev/null'
#find /windows_users/Ben\ Anderson/Pictures/iCloud\ Photos/ -printf '"%h/%f"\n'| grep -i jpg | xargs ls -ladt --time-style=+"%Y %m %d "  | gawk '{print $6 " " $7 " " $9 " " $10 }' | xargs -l bash -c 'cp -u "$2 $3" /windows_e/pics/My\ Pictures/$0/$1-iphone'

# This works, but I'm commenting out because we don't want them
#find /windows_users/Ben\ Anderson/Pictures/iCloud\ Photos/ -maxdepth 2 -mtime +2 -printf '"%h/%f"\n'| grep -i '\(jpg\|mov\)' | xargs ls -ladt --time-style=+"%Y %m %d "  | gawk '{print $6 " " $7}' | xargs -l bash -c 'mkdir -p /windows_e/pics/My\ Pictures/$0/$1-iphone 2> /dev/null'
#find /windows_users/Ben\ Anderson/Pictures/iCloud\ Photos/ -maxdepth 2 -mtime +2 -printf '"%h/%f"\n'| grep -i '\(mov\|jpg\)' | xargs ls -ladt --time-style=+"%Y %m %d "  | gawk '{print $6 " " $7 " " $9 " " $10 " " $11}' | xargs -l bash -c 'cp -u "$2 $3 $4" /windows_e/pics/My\ Pictures/$0/$1-iphone'
