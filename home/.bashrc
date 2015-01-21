set -o vi

export EDITOR=vim
source ~/bin/tmuxinator.bash
export DISABLE_AUTO_TITLE=true

alias j7='export PATH=/usr/java/jdk1.7.0_71/bin:$PATH; export JAVA_HOME="/usr/java/jdk1.7.0_71"; java -version'
alias j8='export PATH=/usr/java/jdk1.8.0_25/bin:$PATH; export JAVA_HOME="/usr/java/jdk1.8.0_25"; java -version'

j7

function tmuxrestart() {
  tmux kill-session -t "$1"
  tmuxinator start "$1"
}
