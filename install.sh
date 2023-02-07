cur_dir=$(pwd)

if [ -f ~/.vimrc ]; then
	mv ~/.vimrc $cur_dir/old_files/
fi
ln -s $cur_dir/vim/.vimrc ~/.vimrc


if [ -f ~/.tmux.conf ]; then
	mv ~/.tmux.conf $cur_dir/old_files/
fi
ln -s $cur_dir/.tmux.conf ~/.tmux.conf
