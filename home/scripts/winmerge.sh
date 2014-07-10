#!/bin/sh
echo Launching WinMergeU.exe: $1 $2
"c:/dev/apps/WinMerge/WinMergeU.exe" -e -ub -dl "Base" -dr "Mine" "$1" "$2"

#left="$(cygpath -wa "$1")"
#right="$(cygpath -wa "$2")"
#/cygdrive/c/dev/apps/WinMerge/WinMergeU /e "$left" "$right" &

