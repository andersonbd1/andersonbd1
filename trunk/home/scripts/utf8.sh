PWD=$(pwd)

cd /cygdrive/c/dev/andersonbd1
~/scripts/rhino.sh ./js/convert_char_enc.js ${*}

cd $PWD
