#!/usr/bin/env bash

info() {
  echo "[INFO] [`date "+%Y/%m/%d-%H:%M:%S"`] $1"
}

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(readlink "$name" || true)"
  done

  pwd -P
  cd "$cwd"
}

replace_dotfile() {
    df=$1

    info "replace dotfile: $df (`pwd`)"

    [ -L "${HOME}/.${df}" ] && rm -f "${HOME}/.${df}"
    [ -f "${HOME}/.${df}" ] && rm -f "${HOME}/.${df}"
    ln -s `pwd`/dotfiles/${df} ~/.${df} 
}

script_dir="$(abs_dirname "$0")"

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew tap Homebrew/bundle
sh brew.sh

# install Dein for Vim
deinDir="${HOME}/.vim/dein.vim"
mkdir -p $deinDir
git clone https://github.com/Shougo/dein.vim.git $deinDir

# set installed zsh & fish
echo "/usr/local/bin/zsh" >> /etc/shells
echo "/usr/local/bin/fish" >> /etc/shells
chsh -s /usr/local/bin/zsh

cd $script_dir
# set up zplug
#curl -fLo ~/.zplug/zplug --create-dirs https://git.io/zplug
#git clone https://github.com/milkbikis/powerline-shell ~/.powerline-shell
#cd ~/.powerline-shell/;./install.sh

cd $script_dir
# install nodebrew, rbenv & ruby-build, pyenv, plenv & perl-build
curl -L git.io/nodebrew | perl - setup
# git clone https://github.com/yyuu/pyenv.git ~/.pyenv
# git clone https://github.com/tokuhirom/plenv.git ~/.plenv

cd $script_dir
# symlinks
if [ -f ~/.zshrc ]; then
  rm ~/.zshrc
fi
replace_dotfile "zshrc"
replace_dotfile "vimrc"
replace_dotfile "gitconfig"
replace_dotfile "tmux.conf"

# set up oh-my-zsh
cd $script_dir
oh-my-zsh/tools/install.sh | ZSH=oh-my-zsh sh

# create hard-link to oh-my-zsh-powerline-theme from oh-my-zsh/themes
cd $script_dir
ln -f oh-my-zsh-powerline-theme/powerline.zsh-theme oh-my-zsh/themes/powerline.zsh-theme

