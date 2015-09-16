set -o vi

export EDITOR=vim
source ~/bin/tmuxinator.bash
export DISABLE_AUTO_TITLE=true

alias j7='export PATH=/usr/java/jdk1.7.0_71/bin:$PATH; export JAVA_HOME="/usr/java/jdk1.7.0_71"; java -version'
alias j8='export PATH=/usr/java/jdk1.8.0_25/bin:$PATH; export JAVA_HOME="/usr/java/jdk1.8.0_25"; java -version'

j7

function mux-restart() {
  sess_id="$(tmux list-sessions | grep $1 | awk -F: '{print $1}')"
  echo "sess_id: <$sess_id>"
  if [ ! -z $sess_id ]; then
    tmux kill-session -t $sess_id
  fi
  tmuxinator start "$1"
}
function mux-kill() {
  tmux kill-session -t $(tmux list-sessions | grep $1 | awk -F: '{print $1}')
}
function mux-attach() {
  tmux attach-session -t $(tmux list-sessions | grep $1 | awk -F: '{print $1}')
}
