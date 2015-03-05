## .dependencies

# Install Vundler for Vim.
echo -e "\x1B[34;1mInstalling Vim Vundler and plugins. This may take a few seconds...\x1B[0m"
#git clone git@github.com:gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
# Install Vim plugins defined in .vimrc file.
# Depending on the location that Vundler installs a plugin, there
# may be an authentication prompt for username and password.
#vim +PluginInstall +qall 2&> /dev/null
vim +PluginInstall +qall 2&>/dev/null