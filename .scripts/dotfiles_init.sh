git clone --recurse-submodules -j8 --bare https://github.com/JasonHallman/dotfiles.git $HOME/.cfg

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

mkdir -p .dotfiles-backup
dotfiles checkout

if [ $? = 0 ]; then
  echo "Checked out dotfiles";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} bash -c "mkdir --parents .dotfiles-backup/{} ; mv {} $_"
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no
