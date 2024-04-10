yavanna() {
read -r -d '' HELP <<-'EOF'
Usage: yavanna [COMMAND] [FILE]

Manager of (conda) environments. Can activate, delete, update, and create conda
environments based on the presence of an environment yaml file.

With no arguments, will activate the environment found in 'environment.yml' in
the current directory. Specify FILE to activate a different environment file
instead. If FILE is a directory, will look for an 'environment.yml' file there.

Other actions can be performed using the commands below. They can all take the
FILE argument as well.

Commands:

  cr   Create the environment
  rm   Delete the environment
  up   Update the environment
  cd   Enter a folder an activate the envionment (if present)

To automatically activate environments when cd-ing, add this to your
'~/.bashrc' file:

alias cd='yavanna cd'

EOF
    # Parse arguments
    envfile="environment.yml"
    if [[ $# -gt 2 ]]; then
        >&2 echo "Invalid argument(s): $@";
        return 1;
    elif [[ $# == 0 ]]; then
        cmd="activate"
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "$HELP";
        return 0;
    elif [[ "$1" == "rm" ]]; then
        cmd="delete"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ "$1" == "up" ]]; then
        cmd="update"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ "$1" == "cr" ]]; then
        cmd="create"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ "$1" == "cd" ]]; then
        cmd="changedir"
        if [[ $# == 1 ]]; then
            directory="$HOME"
        else
            directory=$2
        fi
    elif [[ $# == 1 ]]; then
        envfile="$1"
        cmd="activate"
    else
        >&2 echo "Invalid argument(s): $@";
        return 1;
    fi

    # If the argument is a folder, assume it has an environment.yml
    if [[ -d $envfile ]]; then
        envfile="$envfile/environment.yml"
    fi

    # If using cd, don't fail if there is no environment file so this can work
    # as an alias for cd
    if [[ $cmd == "changedir" ]]; then
        command cd $directory;
        if [[ -e "$envfile" ]]; then
            cmd="activate"
        else
            return 0
        fi
    else
        if [[ ! -e "$envfile" ]]; then
            >&2 echo "Environment file not found:" $envfile;
            return 1;
        fi
    fi

    # Get the environment name from a conda yml file
    envname=$(grep "name: *" $envfile | sed -n -e 's/name: //p')

    # Run the command for each action
    if [[ $cmd == "activate" ]]; then
        conda activate "$envname";

    elif [[ $cmd == "create" ]]; then
        >&2 echo "Creating environment:" $envname;
        conda deactivate;
        mamba env create -f "$envfile";

    elif [[ $cmd == "update" ]]; then
        >&2 echo "Updating environment:" $envname;
        conda activate "$envname";
        mamba env update -f "$envfile";

    elif [[ $cmd == "delete" ]]; then
        >&2 echo "Removing environment:" $envname;
        conda deactivate;
        mamba env remove --name "$envname";
    fi
}
