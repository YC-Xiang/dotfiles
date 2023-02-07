cur_dir=$(pwd)
files=(".vimrc" ".tmux.conf")

if [ ! -d ${cur_dir}/old_files ]; then
	mkdir -p old_files
fi

for file in ${files[@]}
do
	if [ -f ~/${file} ]; then
		mv ~/${file} ${cur_dir}/old_files/
	fi
	ln -s ${cur_dir}/vim/${file} ~/${file}
done

