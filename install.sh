cur_dir=$(pwd)
files=(".vimrc" ".tmux.conf" ".aliases" ".ctags")

if [ ! -d ${cur_dir}/old_files ]; then
	mkdir -p old_files
fi

for file in ${files[@]}
do
    if [ -f ~/${file} ]; then
        mv -i ~/${file} ${cur_dir}/old_files/
    elif [ -L ~/${file} ]; then
        mv -i ~/${file} ${cur_dir}/old_files/
    fi

    ln -s ${cur_dir}/${file} ~/${file}
done

# cat ./.bashrc >> ~/.bashrc

source ~/.bashrc
source ~/.aliases
