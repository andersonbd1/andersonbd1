## tmux / screen combo

I don't actually remember how I installed these tools.  This is a guess.
```
$ brew install tmux
$ brew install ruby
$ gem install tmuxinator
$ gem install byobu
```
If screen wasn't already on the remote machines, I installed it:
```
$ sudo yum install screen
$ # OR
$ sudo apt-get install screen
```

My arrangement uses 3 nested layers:
  1. environment - eg local, ch, da
  1. machine/instance - eg webnode, dbnode
  1. bash session on a box - eg tail-logs, bash, root-bash, long-running-cmd

I keep a tmuxinator config file for each environment:
```
$ ls -ladh ./.tmuxinator/*
...
-rwxr-xr-x  1 banderso  CIS\Domain Users   1.3K Nov 27  2017 ./.tmuxinator/ch.yml
-rwxr-xr-x  1 banderso  CIS\Domain Users   1.7K Nov 27  2017 ./.tmuxinator/da.yml
...
```

If your keys are setup correctly, then the config below will take you right to your remote screen
```
$ cat ~/.tmuxinator/ch.yml 
name: 24-ch
root: ~/

tmux_command: byobu
attach: false

windows:
  - "ldr-1":
    - ssh jump-box
    - ssh ch-webnode-01
    - screen -D -R
  - "db-1":
    - ssh jump-box
    - ssh ch-dbnode-01
    - screen -D -R
  ...
```
My convention for name is `{order}-{filename}`

With this convention, you can make use of these bash functions that I put in my bashrc
```
$ cat ~/.bashrc
...
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
...
```

The remote screen config looks something like this:
```
[banderso@ch-webnode-01 ~]$ cat ~/.screenrc
escape ^@^@

screen -t tomcat-props
screen -t tomcat-logs
screen -t bash
screen -t root-bash
screen -t root-vim
```

To start a tmux session (a session is the outermost level - ie environment)
```
$ h=ch; mux-restart $h; mux-attach $h
```
To exit out of tmux hit `F6`.  You can then re-attach to the same session.
```
$ h=ch; mux-attach $h
```
or start another session
```
$ h=da; mux-restart $h; mux-attach $h
```
to kill a tmux session
```
$ h=da; mux-kill $h
```

To switch between tmux sessions, you can do one of the following:
  * `ctrl-a s` and then use `j` and `k` to move the highlight up and down and hit `enter` to select one
  * `ctrl-k` to move to the above session and `ctrl-j` to move to the below session

To switch windows
  * `ctrl-l` to move to the right and `ctrl-h` to move to the left

To switch screen windows
  * `ctrl-space` followed by `shift-"`
  * use `j` and `k` to select which window you want and then `enter`
