export PATH=~/dotfiles/bin:$PATH
export EDITOR=vim

case $(uname) in
	Darwin )
		export PATH=$PATH:/opt/homebrew/bin
		;;
	Linux )
		DIST=$(cat /etc/*-release | grep "^NAME=" | cut -d '=' -f 2 | tr -d '"')
		case $DIST in
			Debian* )
				export DEBEMAIL="t-ando@advaly.co.jp"
				export DEBFULLNAME="Takumi Ando"
				;;
			Arch* )
				;;
		esac
		;;
esac
