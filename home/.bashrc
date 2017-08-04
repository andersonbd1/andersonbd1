set -o vi

export EDITOR=vim
source ~/bin/tmuxinator.bash
export DISABLE_AUTO_TITLE=true

hash -d java
alias j7='export PATH=/usr/lib/jvm/java-7-oracle/bin:$PATH; export JAVA_HOME="/usr/lib/jvm/java-7-oracle"; java -version'
alias j8='export PATH=/usr/lib/jvm/java-8-oracle/bin:$PATH; export JAVA_HOME="/usr/lib/jvm/java-8-oracle"; java -version'

j7

function mux-test() {
  echo 'hello'
}

function mux-restart() {
  for i in $@
  do 
    sess_id="$(tmux list-sessions | grep $i | awk -F: '{print $1}')"
    echo "sess_id: <$sess_id>"
    if [ ! -z $sess_id ]; then
      tmux kill-session -t $sess_id
    fi
    tmuxinator start "$i"
  done
}
function mux-kill() {
  tmux kill-session -t $(tmux list-sessions | grep $1 | awk -F: '{print $1}')
}
function mux-attach() {
  tmux attach-session -t $(tmux list-sessions | grep $1 | awk -F: '{print $1}')
}
export M2_HOME=/usr/local/apache-maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

alias v1='cd $(echo $PWD | sed "s/aa-uid-db\//aa-uid-db.1.x\//g" )'
alias v2='cd $(echo $PWD | sed "s/aa-uid-db.1.x\//aa-uid-db\//g" )'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
export PATH=~/s3cmd-1.6.1:$PATH

export PGDATABASE=postgres; export PGUSER=aauiddb; export PGPASSWORD=aauiddb; export PAGER=cat;

alias urldecode='python -c "import sys, urllib as ul; \
    print ul.unquote_plus(sys.argv[1])"'

alias urlencode='python -c "import sys, urllib as ul; \
    print ul.quote_plus(sys.argv[1])"'

human_print(){
while read B dummy; do
  [ $B -lt 1024 ] && echo ${B} bytes && break
  KB=$(((B+512)/1024))
  [ $KB -lt 1024 ] && echo ${KB} kilobytes && break
  MB=$(((KB+512)/1024))
  [ $MB -lt 1024 ] && echo ${MB} megabytes && break
  GB=$(((MB+512)/1024))
  [ $GB -lt 1024 ] && echo ${GB} gigabytes && break
  echo $(((GB+512)/1024)) terabytes
done
}
