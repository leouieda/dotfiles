# Config files

This is a repo to keep my ``.*rc`` and other config files versioned.
Just clone it to some directory and copy files to your home to try them out.
**Don't forget to backup your personal files before!**

## Setting up a new computer

I never remember this so I thought I'd write it down:

    cd ~
    git clone git@github.com:leouieda/dotfiles.git
    cp -Rf $HOME/dotfiles/. $HOME/
    rm -rf dotfiles

## Installing bumblebee

Laptops with NVidia cards that use Optimus won't work with the normal drivers.
Either they will be on all the time and kill battery life, or they will be off
always. Installing [bumblebee](http://bumblebee-project.org/) can fix this but
it's a pain to install and the official docs don't provide all the
instructions. This is the best I've found:

https://lenovolinux.blogspot.com.br/2016/05/bumblebee-on-lenovo-t440p-nvidia-gt.html

## Fonts

This repo includes a `.fonts` folder with some TrueType fonts from
[Google fonts](http://www.google.com/fonts#). To make them system accessible,
run:

    sudo fc-cache -f -v


## Subtree

This repo uses `git subtree` to manage external dependecies.
You didn't need to know that, but I do.
A quick cheatsheet to add a new subtree:

`git remote add -f remote_name remote_path`

`git subtree add --prefix path_where_repo_goes remote_name branch --squash`

Now **remember**, separate what you commit to the subtree and to the main repo!
After than, to push changes back to the subtree:

`git subtree push --prefix=path_where_repo_goes remote_name branch`

And to pull changes from a subtree remote:

`git fetch remote_name branch`

`git subtree pull --prefix path_where_repo_goes remote_name branch --squash`

See [this post](http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/) for more info.
