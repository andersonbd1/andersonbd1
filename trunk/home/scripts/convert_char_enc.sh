PWD=$(pwd)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

./rhino.sh ./convert_char_enc.js ${*}

cd $PWD
