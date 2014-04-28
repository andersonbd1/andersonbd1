# base-files version 3.9-3

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# Environment Variables
# #####################

# TMP and TEMP are defined in the Windows environment.  Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences.
unset TMP
unset TEMP

# Alternatively, set them to the Cygwin temporary directory
# or to any other tmp directory of your choice
# export TMP=/tmp
# export TEMP=/tmp

# Or use TMPDIR instead
# export TMPDIR=/tmp

# Shell Options
# #############

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell


# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac


# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"


# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
#alias grep='grep --color=always'              # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #


# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

export PS1='\n\w\n$ '
set -o vi

alias xterm='xterm -fg white -bg darkblue &'
alias xc='cd /cygdrive/c/dev/xc'
#alias mst='cd /cygdrive/c/dev/xc/mst'
alias dev='cd /cygdrive/c/dev'
alias j='cd /cygdrive/c/dev/java'

alias mst='cd /cygdrive/c/dev/xc/mst/svn/${root_dir}'
alias msts='cd /cygdrive/c/dev/xc/mst/svn/${root_dir}/src'
alias mstj='cd /cygdrive/c/dev/xc/mst/svn/${root_dir}/src/java'
alias tc='cd /cygdrive/c/dev/java/tomcat_6.0'
alias msti='cd /cygdrive/c/dev/java/tomcat_6.0/MST-instances/MetadataServicesToolkit'
alias mstl='cd /cygdrive/c/dev/java/tomcat_6.0/MST-instances/MetadataServicesToolkit/logs'
alias tw='cd /cygdrive/c/dev/work/textwise'

alias doc='cd /cygdrive/d/data/Cobalt\ Document/Development/Document'
alias fold='cd /cygdrive/d/cobalt_foldering_main/Foldering'
export PG="/cygdrive/c/dev/tr/pg/"
alias pg="cd $PG"

alias oai='cd /cygdrive/c/dev/xc/oai-toolkit/svn/trunk'

alias w1='export root_dir=trunk'
alias w2='export root_dir=trunk.2'
alias w3='export root_dir=branches/bens_perma_branch'
#w3
alias message='/cygdrive/c/dev/andersonbd1/home/scripts/message.sh'
alias rhino='/cygdrive/c/dev/andersonbd1/home/scripts/rhino.sh'
alias winmerge='/cygdrive/c/dev/andersonbd1/home/scripts/winmerge.sh'
alias tcpmon='cd /cygdrive/c/dev/java/tcpmon-1.0-bin/build/; ./tcpmon.sh & cd ~-'

alias ant='ant.bat'
alias groovy='groovy.bat'

# alias tf='/cygdrive/c/dev/apps/TEE-CLC-11.0.0/tf.cmd'

export PATH="$PATH:/cygdrive/c/dev/tr/pg:/cygdrive/c/dev/andersonbd1/home/scripts"

#xhost +

# $ ls -lad "C:\dev\tr\foldering\eclipse_workspace\Foldering\ant"
# cygwin warning:
#   MS-DOS style path detected: C:\dev\tr\foldering\eclipse_workspace\Foldering\ant
#   Preferred POSIX equivalent is: /cygdrive/c/dev/tr/foldering/eclipse_workspace/Foldering/ant
#   CYGWIN environment variable option "nodosfilewarning" turns off this warning.
#   Consult the user's guide for more details about POSIX paths:
#     http://cygwin.com/cygwin-ug-net/using.html#using-pathnames
# drwxr-xr-x 1 u0153490 Domain Users 0 Nov 28 15:16 C:\dev\tr\foldering\eclipse_workspace\Foldering\ant

export nodosfilewarning="true"
export VIMDIR="C:\dev\apps\Vim"

# unsetting SHELL let me run F7 (xmllint) in gvim.  Not sure yet if there are other consequences.
# unset SHELL
# but screwed up screen

export TFPT_ONLINE_EXCLUDE="build,buildTempLocation,Logs,TestResults,unitTestBin,dist,bin,obj"

export AND=/cygdrive/c/dev/andersonbd1
echo "hello"
export PATH="/usr/bin:$PATH"

alias j6='export PATH=/cygdrive/c/dev/java/jdk1.6.0_29/bin:$PATH; export JAVA_HOME="c:\dev\java\jdk1.6.0_29"; java -version'
alias j7='export PATH=/cygdrive/c/dev/java/jdk1.7.0_13/bin:$PATH; export JAVA_HOME="c:\dev\java\jdk1.7.0_13"; java -version'
alias j8='export PATH=/cygdrive/c/dev/java/jdk1.8/bin:$PATH; export JAVA_HOME="C:\dev\java\jdk1.8"; java -version'


alias curl=/cygdrive/c/dev/apps/curl


alias findx="find . -printf '\"%h/%f\"\n'"
export findxx="find . -printf '\"%h/%f\"\n'"

alias cmd="cygstart c:/windows/system32/cmd"

export GREP_FILTER='\(bin-test\|bin\|\.metadata\|test\|template\|ant\)'

#export GREP_OPTIONS='–color=auto'
