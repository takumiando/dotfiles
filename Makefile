EXCLUDES	:= .DS_Store .git .gitmodules .travis.yml
TARGET		:= $(wildcard .??*)
DIR		:= $(PWD)
DOTFILES	:= $(filter-out $(EXCLUDES), $(TARGET))

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init:
	@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)
