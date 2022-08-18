#!/bin/bash

################################################################################
#  Install dotfiles as a bare git repository. Conflicting files found during   #
#  installation can be deleted or moved to "dotfiles.backup"                   #
#                              Dependencies: git, rm, sudo                     #
################################################################################

set -o errexit
export GIT_WORK_TREE="$HOME"
export GIT_DIR="$GIT_WORK_TREE/.dotfiles"
backupdir="$GIT_WORK_TREE/dotfiles.backup"
dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
repository="https://github.com/etherrorcode404/dotfiles.git"
exclude=(".gitmodules" "README.md" "Desktop-entries" "Dots-install.sh" "Debian-install.sh")

function clone(){
  git clone --bare "$repository" 
}

function delete(){
  for files in $(git ls-tree -r --name-only HEAD); do
    if [[ -e "$files" ]]; then
      sudo rm -rf "$files"
    fi
  done
}

function backup(){
  for files in $(git ls-tree -r --name-only HEAD); do
    if [[ -e "$file" ]]; then
      mkdir -p "$backupdir"
      mv "$files" "$backupdir"
    fi
  done
}

function install(){
  git switch -f $branch
  git checkout
  git submodule update --init
  git config status.showUntrackedFiles no
  git config core.worktree "$GIT_WORK_TREE"
  git config alias.edit '!env -C "${GIT_PREFIX:-.}" $EDITOR'
  git sparse-checkout set "*" "${exclude[@]/#/\!}"
}

clone
delete  
#backup
install 
