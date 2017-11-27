export CLICOLOR=1

USERTYPE="0"

FIRSTTEXT="\[\e[38;5;224m\]"
FIRSTBG="\[\e[48;5;57m\]"
FIRSTFG="\[\e[38;5;57m\]"

SECONDTEXT="\[\e[38;5;254m\]"
SECONDBG="\[\e[48;5;29m\]"
SECONDFG="\[\e[38;5;29m\]"

THIRDTEXT="\[\e[38;5;233m\]"
THIRDBG="\[\e[48;5;78m\]"
THIRDFG="\[\e[38;5;78m\]"

RESET="\[\e[m\]"
ARROW=""
BRANCHICON=""

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

set_bash_prompt() {
    PS1="$FIRSTTEXT$FIRSTBG "
    
    if [ "$USERTYPE" == "0" ]; then
        PS1="$PS1\$"
    else
        PS1="$PS1\u@\h"
    fi

    DIRNAME='$(echo $(dirname \w)|sed -e "s;\(/.\)[^/]*;\1;g")/$(basename \w)'

    PS1="$PS1 $FIRSTFG$SECONDBG$ARROW$SECONDTEXT $DIRNAME "

    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        PS1="$PS1$SECONDFG$THIRDBG$ARROW$THIRDTEXT $BRANCHICON ${BRANCH}${STAT} $RESET$THIRDFG$ARROW$RESET "
    else
        PS1="$PS1$RESET$SECONDFG$ARROW$RESET "
    fi
}

PROMPT_COMMAND=set_bash_prompt

export ANDROID_HOME="/opt/local/share/java/android-sdk-macosx"

export PATH="$HOME/.yarn/bin:$PATH:~/Library/Python/3.5/bin:/opt/local/bin:/opt/local/sbin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:~/.yarn-global/bin:~/.bin"

alias vim='/opt/local/bin/vim'
alias grep='/opt/local/bin/grep'

function co() {
    git checkout -b $1
    git push --set-upstream origin $1
}

function foo() {
    sfdx force:org:open -u $1
}
