for p in $(cat packages | grep -v '^#')
do 
  echo $p
  chocolatey install -y $p
done
