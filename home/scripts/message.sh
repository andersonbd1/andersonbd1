export CLASSPATH=/cygdrive/c/dev/java/rhino1_7R2/js.jar:/cygdrive/c/dev/java/smack_3_1_0/smack.jar;
#export CLASSPATH="c:/dev/java/rhino1_7R2/js.jar;c:/dev/java/smack_3_1_0/smack.jar;$CLASSPATH"
my_pwd=$PWD
cd ~/scripts
java -classpath `cygpath -wp $CLASSPATH` org.mozilla.javascript.tools.shell.Main send_msg.js "benanderson.message@gmail.com" message99 "benanderson@benanderson.us" "ping" 1> /dev/null 2> /dev/null
cd $my_pwd
