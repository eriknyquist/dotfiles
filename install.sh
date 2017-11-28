#!/bin/bash

# Installs my dotfiles, and vim (+plugins)

vundle_url=https://github.com/VundleVim/Vundle.vim
dotfiles_url=https://github.com/eriknyquist/dotfiles
dotfiles_clone=$(mktemp)
bashrc_source_cmd="source ~/.bashrc.extra"
exclude_dirs_pattern="s/\.\.\///g; s/\.\///g; s/\.git\///g"

log() {
    printf "\n%s\n" "$1"
}

# Test if script is running from a local clone of dotfiles repo
git remote -v | grep "github.com/eriknyquist/dotfiles" &> /dev/null
ret=$?

# grep returned an error
if [ $ret == 2 ]
then
    exit $ret
fi

# clone dotfiles repo if we're not already in it
if [ $ret != 0 ]
then
    git clone "$dotfiles_url" "$dotfiles_clone" || exit 1
    cd "$dotfiles_clone"
fi

# Install vim and vundle
log "Installing vim and Vundle (sudo required)"
sudo apt-get install vim
 [ -d ~/.vim/bundle/Vundle.vim ] || git clone "$vundle_url" ~/.vim/bundle/Vundle.vim 

files=$(ls -pd .?* | grep -v /$ | sed '/^$/d')
directories=$(ls -pd .?* | grep  /$ | sed "$exclude_dirs_pattern" | sed '/^$/d')

echo ""
echo "The following files/directories will be copied, and overwritten if they"
echo "already exist:"
echo ""
echo "$files" "$directories"
echo ""

while true; do
    read -p "Are you sure you want to do it? [yes/no]: " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Quitting."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Continuing"

# Copy files
log "Copying files from $(pwd) to $HOME"
while read -r dotfile
do
    echo "$dotfile"
    cp "$dotfile" "$HOME"
done <<< "$files"

# Copy directories
log "Copying directories from $(pwd) to $HOME"
while read -r dir
do
    echo "$dir"
    cp -r "$dir" "$HOME"
done <<< "$directories"

log "Setting up dotfiles"

# Include my bashrc (if not already included)
grep "^$bashrc_source_cmd *$" ~/.bashrc
if [ $? -eq 0 ]
then
    echo "~/.bashrc.extra already included in ~/.bashrc, skipping..."
else
    echo "source ~/.bashrc.extra" >> ~/.bashrc

    # Re-load bashrc
    source ~/.bashrc
fi

# Re-load .inputrc
bind -f ~/.inputrc

# Install Vundle plugins
log "Installing Vundle plugins"
vim +PluginInstall +qall
