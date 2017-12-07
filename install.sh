#!/bin/bash

# Installs my dotfiles, and vim (+plugins)

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

bashrc_source_cmd="source $dest/.bashrc.extra"

echo "Installing dotfiles in $dest"

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
[ -d "$dest"/.vim/bundle/Vundle.vim ] || git clone "$vundle_url" "$dest"/.vim/bundle/Vundle.vim

[ -d "$dest"/.vim/doc ] || mkdir -p "$dest"/.vim/doc
cp "cheat.txt" "$dest"/.vim/doc

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
    echo "source $dest/.bashrc.extra" >> "$dest"/.bashrc
fi

# Install Vundle plugins
log "Installing Vundle plugins"
chmod -R a+rw "$dest"/.vim
vim +PluginInstall +helptags "$dest"/.vim/doc +qall -E

echo ""
echo "Dotfiles are installed. Run the folowing shell command"
echo "to activate the changes without rebooting:"
echo ""
echo "  source $dest/.bashrc; bind -f $dest/.inputrc"
echo ""
