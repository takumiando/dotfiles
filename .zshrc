# ========== Function setting ==========
# Complete command options
autoload -U compinit
compinit

# Check and correct command
setopt correct

# Colors
export LS_COLORS='di=34;01:ln=35:so=32:pi=33:ex=31;01:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=34;01' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# Remove duplicated elements automatically
typeset -U path cdpath fpath
path=(
  $HOME/dotfiles/bin(N-/)
  $HOME/.local/bin(N-/)
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  $path
)

# Commands history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt extended_history
function history-all { history -E 1}
setopt histignorealldups sharehistory

# Use invalid command as directory name to move
setopt auto_cd
# Select complete element by TAB
setopt auto_menu
# Show complete elements list
setopt auto_list
# Show filetype mark in complete list
setopt list_types
# Add "/" to complete directory name automatically
setopt auto_param_slash

# Key bindings
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^R' history-incremental-search-backward
bindkey '^F' history-incremental-pattern-search-forward
# Switch back to background job by C-z
fancy-ctrl-z () {
	 if [[ $#BUFFER -eq 0 ]]; then
		BUFFER="fg"
		zle accept-line
	else
		zle push-input
		zle clear-screen
	fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# ========== Prompt setting ==========
autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "!"
zstyle ':vcs_info:*' formats "%K{yellow}%F{black}%b%F{white}%c%u%f%k"
zstyle ':vcs_info:*' actionformats "%K{magenta}%F{black}%b%F{white}%c%u%f%k"

BAT_PERCENT="/sys/class/power_supply/BAT0/capacity"
BAT_STATUS="/sys/class/power_supply/BAT0/status"
bat () {
	if [ -f ${BAT_PERCENT} ]; then
		PERCENT=$(cat ${BAT_PERCENT})

		if [ -f ${BAT_STATUS} ]; then
			STATUS=$(cat ${BAT_STATUS})
			if [ ${STATUS} != "Discharging" ]; then
				ICON="🔌"
			else
				ICON=""
			fi
		fi
		echo " ${ICON}${PERCENT}%%"
	fi
}

precmd () {
	vcs_info
}

local git='${vcs_info_msg_0_}'
local dir='%{%K{cyan}%}%(5~,%-2~/.../%2~,%~)%{%k%}'
local hostname='%K{blue}${HOST}%k'
RPROMPT='%F{yellow}%D{%T}$(bat)%f'
PROMPT="%F{black}${hostname}${dir}%f${git}
%F{yellow}->%f "

# ========== Environment variables ==========
export EDITOR=/usr/bin/vim
export LESS=-R

# ========== Alias ==========
# ls
case ${OSTYPE} in
	darwin*)
		alias ls='ls -FG'
		;;
	linux*)
		alias ls='ls --color -F'
		;;
esac
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lh='ls -lh'
alias lla='ls -la'
# Open Manpage in japanese
alias jman='LANG=ja_JP.UTF-8 man'
# Editors
alias vi='vim'
alias emacs='emacs -nw'
# Tools
alias diff='diff -uprN'
alias ag='ag --color-match "39;46" --color-path "1;34" --color-line-number "1;30"'

# Set color scheme from pywal
if [ ${TERM} = "st-256color" ] && [ -z ${SSH_TTY} ]; then
	if [ -f ${HOME}/.wallpaper ]; then
		read WP < ${HOME}/.wallpaper
		wal -q -i ${WP}
	fi
fi
