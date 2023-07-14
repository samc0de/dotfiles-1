set -e

# Assumes vim w/ python3, curl & git installed.
mkdir -p ~/.vim ~/.vimdir

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

curl https://raw.githubusercontent.com/samc0de/dotfiles-1/main/.vimrc >> ~/.vimrc

vim -c PluginUpdate
