export CLASSPATH=/cygdrive/c/java/rhino1_7R1/js.jar:/cygdrive/c/java/smack_3_0_4/smack.jar;
my_pwd=$PWD
cd ~/scripts
java -classpath `cygpath -wp $CLASSPATH` org.mozilla.javascript.tools.shell.Main send_msg.js "benanderson.us@gmail.com" password "benanderson@benanderson.us" "ping" 1> /dev/null 2> /dev/null
cd $my_pwd