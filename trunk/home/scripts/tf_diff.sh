tf view $1 > $PG/tfs_temp/temp
left="$(cygpath -wa "$PG/tfs_temp/temp")"
right="$(cygpath -wa "$1")"
echo $left
echo $right
/cygdrive/c/Program\ Files\ \(x86\)/WinMerge/WinMergeU /e "$left" "$right" &
#winmerge $PG/tfs_temp/${1} $1 
