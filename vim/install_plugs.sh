path=~/.vim/pack/vendor/start

if [ ! -d "$path" ];
then
echo "mkdir -p $path"
mkdir -p $path
fi

cd $path

if [ ! -d $path/ctrlp ];
then
    git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim.git $path/ctrlp
fi

if [ ! -d $path/ack.vim ];
then
    git clone --depth=1 https://github.com/mileszs/ack.vim.git $path/ack.vim
fi

if [ ! -d $path/nerdtree ];
then
	git clone https://github.com/preservim/nerdtree.git $path/nerdtree
fi

