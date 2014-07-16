PWD_DIR=$(pwd)
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SRC_DIR/2014

rm index.html
echo "<html manifest=\"officium.php\">" > index.html
echo "<head>" >> index.html
echo "</head>" >> index.html
echo "<body>" >> index.html

for f in $(ls -1 O*.html)
do
  echo $f
  echo "<a href=\"$f\">$f</a><br/>" >> index.html
done

echo "</body>" >> index.html
echo "</html>" >> index.html

rm officium.php

echo "<?php header('Content-Type: text/cache-manifest'); ?>" > officium.php
echo "CACHE MANIFEST" >> officium.php
echo "index.html" >> officium.php

for f in $(ls -1 O*.html)
do
  echo $f >> officium.php
done

cd $PWD_DIR
