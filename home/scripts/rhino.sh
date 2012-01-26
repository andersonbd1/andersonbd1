#export CLASSPATH=/cygdrive/c/dev/java/rhino1_7R2/js.jar:/cygdrive/c/dev/java/smack_3_1_0/smack.jar;
export CLASSPATH="c:/dev/java/rhino1_7R3/js.jar;c:/dev/java/smack_3_2_1/smack.jar;"
#java -classpath `cygpath -wp $CLASSPATH` org.mozilla.javascript.tools.shell.Main -encoding utf8 ${*}
java -classpath $CLASSPATH org.mozilla.javascript.tools.shell.Main -encoding utf8 ${*}
