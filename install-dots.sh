#!/bin/bash

################################################################################
#  Install dotfiles as a bare git repository. Conflicting files found during   #
#  installation are moved to $HOME/.delete and deleted later. comment "delete" #
#  backup instead.                                                             #
#                              Dependencies: git, rm, sudo                     #
################################################################################

set -o errexit
export GIT_WORK_TREE="$HOME"
export GIT_DIR="$GIT_WORK_TREE/.dotfiles"
dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
backupdir="$GIT_WORK_TREE/dotfiles.backup"
repository="https://github.com/etherrorcode404/dotfiles.git"
exclude=(".gitmodules" "README.md")

function clone(){
  git clone --bare "$repository" "$GIT_DIR"
}

function delete(){
  for file in $(git ls-tree -r --name-only HEAD); do
    if [[ -e "$file" ]]; then
      mkdir -p "$backupdir"
      mv "$file" "$backupdir"
      rm -rf "$backupdir"
    fi
  done
}

function backup(){
  for file in $(git ls-tree -r --name-only HEAD); do
    if [[ -e "$file" ]]; then
      mkdir -p "$backupdir"
      mv "$file" "$backupdir"
    fi
  done
}

function install(){
  git checkout
  git submodule update --init
  git config status.showUntrackedFiles no
  git config core.worktree "$GIT_WORK_TREE"
  git config alias.edit '!env -C "${GIT_PREFIX:-.}" $EDITOR'
  git sparse-checkout set "*" "${exclude[@]/#/\!}"
  sudo apt install $(cat ~/dotfiles/debian-packages-manually-installed.txt | xargs) --reinstall
}

clone
backup
delete  
install 
