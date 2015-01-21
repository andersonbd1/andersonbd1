PWD_DIR=$(pwd)
export SCRIPT_DIR='/mydev/andersonbd1/vagrant/installation_scripts'
export SD=${SCRIPT_DIR}
export HD=/home/vagrant
export ID=${HD}/installation_dir

mkdir $ID 2> /dev/null
cd $ID

echo "INSTALLATION_DIRECTORY: ${ID}"

#exec 1>> everything.out 2>&1

#${SCRIPT_DIR}/everything.sh 1> everything.out 2>&1
${SCRIPT_DIR}/everything.sh 1> everything.out 2>&1

cd $PWD_DIR
