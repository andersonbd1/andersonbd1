. /etc/profile
export PATH="/usr/bin:$PATH"
#export CLASSPATH="/cygdrive/c/dev/java/rhino1_7R3/js.jar:/cygdrive/c/dev/java/smack_3_2_1/smack.jar";
export CLASSPATH='.;c:\dev\java\rhino1_7R3\js.jar;c:\dev\java\smack_3_2_1\smack.jar';
#export WIN_CLASSPATH=$(cygpath -wp $CLASSPATH)
#echo $WIN_CLASSPATH
#export CLASSPATH="c:/dev/java/rhino1_7R2/js.jar;c:/dev/java/smack_3_1_0/smack.jar;$CLASSPATH"
my_pwd=$PWD
# this did work, but now it isn't
#dir=$(dirname $(which $0));
#cd $dir
#echo "dir: $dir"
cd /cygdrive/c/dev/andersonbd1/home/scripts
java -classpath $CLASSPATH org.mozilla.javascript.tools.shell.Main send_msg.js "benanderson.message@gmail.com" message99 "benanderson@benanderson.us" "ping" 1> /dev/null 2> /dev/null
#java -classpath $CLASSPATH org.mozilla.javascript.tools.shell.Main send_msg.js "benanderson.message@gmail.com" message99 "benanderson@benanderson.us" "ping" 1> /dev/null 
cd $my_pwd
