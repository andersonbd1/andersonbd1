export CLASSPATH=/cygdrive/c/dev/java/rhino1_7R2/js.jar:/cygdrive/c/dev/java/smack_3_1_0/smack.jar;
java -classpath `cygpath -wp $CLASSPATH` org.mozilla.javascript.tools.shell.Main -encoding utf8 ${1} ${2} ${3} ${4}
