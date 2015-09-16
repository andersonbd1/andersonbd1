#/bin/bash

PWD_DIR=$(pwd)
SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "SRC_DIR: ${SRC_DIR}"
. ${SRC_DIR}/set_env.sh

mkdir $ID 2> /dev/null
cd $ID

echo "INSTALLATION_DIRECTORY: ${ID}"

sudo -E -u ${DEV_USER} ${SCRIPT_DIR}/everything.sh 1> everything.out 2> everything.out

cd $PWD_DIR
