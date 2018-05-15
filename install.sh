#!/bin/bash

# Installs my dotfiles, and vim (+plugins)

install_pkgs="git vim ctags"

main_user=$(logname)
vundle_url=https://github.com/VundleVim/Vundle.vim
dotfiles_url=https://github.com/eriknyquist/dotfiles
dotfiles_clone=$(mktemp -d)
exclude_dirs_pattern="s/\.\.\///g; s/\.\///g; s/\.git\///g"

log() {
    printf "\n%s\n" "$1"
}

if [ $# -gt 0 ]
then
    dest="$1"
else
    dest="$HOME"
fi

vim_dest="$dest"/.vim
vim_doc="$vim_dest"/doc
vundle_dest="$vim_dest"/bundle/Vundle.vim
bashrc_source_cmd="source $dest/.bashrc.extra"

log "Installing packages"
apt-get install -y $install_pkgs

# Test if script is running from a local clone of dotfiles repo
git remote -v | grep $dotfiles_url &> /dev/null
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

[ -d "$vundle_dest" ] || git clone "$vundle_url" "$vundle_dest"

[ -d "$vim_doc" ] || mkdir -p "$vim_doc"
cp "cheat.txt" "$vim_doc"

files=$(ls -pd .?* | grep -v /$ | sed '/^$/d')
directories=$(ls -pd .?* | grep  /$ | sed "$exclude_dirs_pattern" | sed '/^$/d')

# Copy files
log "Copying files from $(pwd) to $dest"
while read -r dotfile
do
    echo "$dotfile"
    cp "$dotfile" "$dest"
done <<< "$files"

# Copy directories
log "Copying directories from $(pwd) to $dest"
while read -r dir
do
    echo "$dir"
    cp -r "$dir" "$dest"
done <<< "$directories"

log "Setting up dotfiles"

# Include my bashrc (if not already included)
grep "^$bashrc_source_cmd *$" "$dest"/.bashrc
if [ $? -eq 0 ]
then
    echo ".bashrc.extra already included in .bashrc, skipping..."
else
    echo "$bashrc_source_cmd" >> "$dest"/.bashrc
fi

log "Setting git configuration"

# Set git configuration
sudo -u $main_user git config --global user.name "Erik Nyquist"
sudo -u $main_user git config --global user.email "eknyquist@gmail.com"
sudo -u $main_user git config --global core.editor "vim"

# Install Vundle plugins
log "Installing Vundle plugins"
chmod -R a+rw "$vim_dest"
sudo -u $main_user vim -u "$dest"/.vimrc +silent +PluginInstall +helptags "$vim_doc" +qall -E

echo ""
echo "Dotfiles are installed. Run the folowing shell command"
echo "to activate the changes without rebooting:"
echo ""
echo "  source $dest/.bashrc; bind -f $dest/.inputrc"
echo ""
