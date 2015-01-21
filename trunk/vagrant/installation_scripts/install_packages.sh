for p in $(cat ${SD}/deb_list | grep -v '^#')
do
  echo "sudo apt-get -y install ${p}"
  sudo apt-get -y install ${p}
done
