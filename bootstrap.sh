dotfiles_dir="$HOME/.dotfiles"
ohmyzsh_dir="$dotfiles_dir/oh-my-zsh"


function install_pyenv_plugins() {
    for name in $@
    do
        local plugin_name="$(echo $name | cut -d '/' -f 2)"
        local plugin_folder="$PYENV_ROOT/plugins/$plugin_name"
        local repo_url="git://github.com/$name.git"

        if [ ! -d $plugin_folder ]; then
            git clone $repo_url $plugin_folder
            echo "[✓]$plugin_name"
        fi
    done
    return 0
}


function has_command() {
    if command -v $* 1>/dev/null 2>&1; then
        return 0
    fi
    return 1
}


if ! has_command "brew"; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


if [ ! -d $ohmyzsh_dir ]; then
    echo "Installing oh-my-zsh..."
    git clone https://github.com/robbyrussell/oh-my-zsh $ohmyzsh_dir
fi


echo "Installing essential packages..."
brew install autojump vim pyenv pyenv-virtualenv proxychains-ng node tmux yarn gnu-sed\
	cmake python pipenv mosh docker docker-machine zsh-syntax-highlighting neovim


if [ ! -f ~/.vimrc ]; then
    echo "Linking vimrc..."
    ln -s $dotfiles_dir/vimrc ~/.vimrc
fi


if [ ! -f ~/.zshrc ]; then
    echo "Linking zshrc..."
    ln -s $dotfiles_dir/zshrc ~/.zshrc
fi


if [ ! -f ~/.tmux.conf ]; then
    echo "Linking tmux.conf..."
    ln -s $dotfiles_dir/tmux.conf ~/.tmux.conf
fi


if [ ! -d ~/.config/nvim ]; then
    echo "Create nvim config folder..."
    mkdir -p ~/.config/nvim
fi

if [ ! -f ~/.config/nvim/init.vim ]; then
    echo "Create init.vim config file for neovim..."
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
    gsed -i "a\let &packpath = &runtimepath" ~/.config/nvim/init.vim
    gsed -i "a\source ~/.vimrc" ~/.config/nvim/init.vim
fi


echo "Install pyenv plugins..."
install_pyenv_plugins "concordusapps/pyenv-implict" "pyenv/pyenv-doctor"

# if [ ! -f ~/.vim/autoload/plug.vim ]; then
#     echo "Installing plug.vim..."
#     curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
# 	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# fi

# echo "Install plugins of vim..."


echo 'All done!'
