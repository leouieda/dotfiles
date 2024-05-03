# My personal config files

This is a repository to keep my linux configuration files and utilities.
**Don't forget to backup your personal files before trying to run the commands
below!**

## Setting up a new computer

I never remember this so I thought I'd write it down.

1. Install [GNU `stow`](https://www.gnu.org/software/stow/manual/stow.html)
1. Clone the repository:
   ```bash
   git clone git@github.com:leouieda/dotfiles.git
   ```
1. Create the symlinks in the home directory:
   ```bash
   make sync
   ```
