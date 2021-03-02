source /etc/bash_completion

shopt -s histappend

HISTSIZE=10000000
HISTFILESIZE=10000000
PROMPT_COMMAND="history -a"

alias ls='ls --color -F'
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lh='ls -lh'
alias lla='ls -la'
alias vi='vim'
alias diff='diff -uprN'
alias ag='ag --color-match "39;46" --color-path "1;34" --color-line-number "1;30"'

end="\033[00m"
black="\033[30m"
blackb="\033[40m"
white="\033[37m"
whiteb="\033[47m"
red="\033[31m"
redb="\033[41m"
green="\033[32m"
greenb="\033[42m"
yellow="\033[33m"
yellowb="\033[43m"
blue="\033[34m"
blueb="\033[44m"
magenta="\033[35m"
magentab="\033[45m"
cyan="\033[36m"
cyanb="\033[46m"
blink="\033[05m"

black () {
	echo -e "${black}${1}${end}"
}

blackb () {
	echo -e "${blackb}${1}${end}"
}

white () {
	echo -e "${white}${1}${end}"
}

whiteb () {
	echo -e "${whiteb}${1}${end}"
}

red () {
	echo -e "${red}${1}${end}"
}

redb () {
	echo -e "${redb}${1}${end}"
}

green () {
	echo -e "${green}${1}${end}"
}

greenb () {
	echo -e "${greenb}${1}${end}"
}

yellow () {
	echo -e "${yellow}${1}${end}"
}

yellowb () {
	echo -e "${yellowb}${1}${end}"
}

blue () {
	echo -e "${blue}${1}${end}"
}

blueb () {
	echo -e "${blueb}${1}${end}"
}

magenta () {
	echo -e "${magenta}${1}${end}"
}

magentab () {
	echo -e "${magentab}${1}${end}"
}

cyan () {
	echo -e "${cyan}${1}${end}"
}

cyanb () {
	echo -e "${cyanb}${1}${end}"
}

blink () {
	echo -e "${blink}${1}${end}"
}

ps_host () {
	black $(blueb $HOSTNAME)
}

ps_pwd () {
	PWDM=$(pwd | sed -e "s#^$HOME#~#")
	LEVEL=$(echo $PWDM | grep -o '/' | wc -l)

	if [ $LEVEL -gt 4 ]; then
		PWDF=$(echo $PWDM | cut -d '/' -f 1-2)
		PWDB=$(echo $PWDM | rev | cut -d '/' -f 1-2 | rev)
		PS_PWD=${PWDF}/.../${PWDB}
	else
		PS_PWD=$PWDM
	fi

	black $(cyanb $PS_PWD)
}

ps_git () {
	UNSTAGED=$(git status --short 2> /dev/null | grep "^ M " > /dev/null; echo $?)
	STAGED=$(git status --short 2> /dev/null | grep "^M " > /dev/null; echo $?)
	NEW=$(git status --short 2> /dev/null | grep "^A " > /dev/null; echo $?)
	GITPS1=$(__git_ps1 | sed -e 's/(//g' -e 's/)//g' -e 's/ //g')
	BRANCH=$(echo $GITPS1 | cut -d '|' -f 1)
	ACTION=$(echo $GITPS1 | cut -d '|' -f 2- -s)

	PICT=''
	if [ $STAGED -eq 0 ] || [ $NEW -eq 0 ]; then
		PICT='+'
	fi
	if [ $UNSTAGED -eq 0 ]; then
		PICT=${PICT}'!'
	fi

	if [ -z $ACTION ]; then
		black $(yellowb ${BRANCH}$(blink ${PICT}))
	else
		blink $(black $(yellowb ${BRANCH}${PICT}))
	fi
}

PS1='$(ps_host)$(ps_pwd)$(ps_git)
> '
