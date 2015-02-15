sudo apt-add-repository -y ppa:brightbox/ruby-ng-experimental &&
sudo apt-get update

for p in $(cat ${SD}/deb_list | grep -v '^#')
do
  echo "sudo apt-get -y install ${p}"
  sudo apt-get -y install ${p}
done
