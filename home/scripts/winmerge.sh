left="$(cygpath -wa "$1")"
right="$(cygpath -wa "$2")"
/cygdrive/c/Program\ Files\ \(x86\)/WinMerge/WinMergeU /e "$left" "$right" &
