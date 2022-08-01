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

## HiDPI

My Dell XPS13 has an HiDPI screen (3200 x 1800) and some things
look way too small by default. See https://wiki.archlinux.org/index.php/HiDPI
for resources.

**Zoom:** In `~/.config/zoomus.conf` set `scaleFactor=2` and `autoScale=false`.
See https://superuser.com/questions/1381054/how-to-enable-hidpi-support-on-zoom-us-linux-client
