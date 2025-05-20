# Helpers for working with git


# Prune merged remote branches
git-poda() {
    echo "Looking for remote branches to prune..."
    # Capture the output to check if there were any branches to prune in the first place
    toprune=`git remote prune origin --dry-run`
    nbranches=`echo "$toprune" | wc -l`
    if [[ "$nbranches" == "1" ]]; then
        echo "The tree is clean. Move along."
        return 0
    fi
    echo "$toprune"
    read -p "Prune these merged remote branches? [y/N] " response
    clean=`echo "$response" | tr "[:upper:]" "[:lower:]"`
    # Set the default value to No"
    clean="${clean:-no}"
    if [[ "$clean" == "y" ]] || [[ "$clean" == "yes" ]]; then
        git remote prune origin;
    elif [[ "$clean" == "n" ]] || [[ "$clean" == "no" ]]; then
        echo "Alright, alright. I'll stop.";
    else
        echo "Invalid reponse: $response"
        return 1
    fi
    echo "Done."
    return 0
}


# Open the git remote repository in Firefox
repo() {
    firefox `git remote get-url origin | sed 's/git@\([a-z]*\)\.\([a-z]*\):\(.*\)/https:\/\/\1\.\2\/\3/'`
}
