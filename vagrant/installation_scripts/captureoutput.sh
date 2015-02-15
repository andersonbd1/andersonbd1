PWD_DIR=$(pwd)
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
${SRC_DIR}/set_env.sh

mkdir $ID 2> /dev/null
cd $ID

echo "INSTALLATION_DIRECTORY: ${ID}"

#exec 1>> everything.out 2>&1

#${SCRIPT_DIR}/everything.sh 1> everything.out 2>&1
${SCRIPT_DIR}/everything.sh 1> everything.out 2>&1

cd $PWD_DIR
