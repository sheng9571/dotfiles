install:
	ln -fs `pwd`/zshrc	"${HOME}/.zshrc"
	ln -fs `pwd`/tmux.conf	"${HOME}/.tmux.conf"
	ln -fs `pwd`/gitconfig	"${HOME}/.gitconfig"
	ln -fs `pwd`/gitignore	"${HOME}/.gitignore"
	ln -fs `pwd`/bashrc	"${HOME}/.bashrc"
	ln -fs `pwd`/inputrc	"${HOME}/.inputrc"
	ln -fs `pwd`/vimrc	"${HOME}/.vimrc"
	ln -fs `pwd`/vim	"${HOME}/.vim"
	ln -fs `pwd`/gdbinit	"${HOME}/.gdbinit"

clean:
	rm -rf ${HOME}/.zshrc ${HOME}/.tmux.conf ${HOME}/.gitconfig ${HOME}/.gitignore ${HOME}/.bashrc ${HOME}/.inputrc ${HOME}/.vimrc ${HOME}/.vim ${HOME}/.gdbinit
