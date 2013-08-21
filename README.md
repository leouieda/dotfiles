# Config files

This is a repo to keep my ``.*rc`` and other config files versioned.
Just clone it to some directory and copy files to your home to try them out.
**Don't forget to backup your personal files before!**

# Subtree

This repo uses `git subtree` to manage external dependecies.
You didn't need to know that, but I do.
A quick cheatsheet to add a new subtree:

`git remote add -f remote_name remote_path`

`git subtree add --prefix path_where_repo_goes remote_name branch --squash`

And to pull changes from a subtree remote:

`git fetch remote_name branch`

`git subtree pull --prefix path_where_repo_goes remote_name branch --squash`

