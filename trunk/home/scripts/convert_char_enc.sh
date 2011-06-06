PWD=$(pwd)

cd 
./scripts/rhino.sh ./scripts/convert_char_enc.js ${*}

cd $PWD
