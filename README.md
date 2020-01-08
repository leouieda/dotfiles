# Config files

This is a repository to keep my linux configuration files and utilities. To use
it, clone it to some directory and copy files to your home to try them out.
**Don't forget to backup your personal files before!**

## Setting up a new computer

I never remember this so I thought I'd write it down.

1. Clone the repository:    
   ```bash
   git clone git@github.com:leouieda/dotfiles.git
   ```
2. Copy the files to the home directory (including the `.git` directory):
   ```bash
    cp -Rf $HOME/dotfiles/. $HOME/
    ```
3. Remove the original clone because `$HOME` is now the clone:
   ```bash
   rm -rf dotfiles
   ```
