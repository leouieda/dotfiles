# Useful bash functions

# Jupyter
###############################################################################
nbtunnel() {
    # Start an SSH tunnel to a remove Jupyter server
    if [[ $# -le 0 ]]; then
        echo "Usage: nbtunnel LOCAL_PORT REMOTE_PORT REMOTE_HOST"
        echo ""
        echo "Create an SSH tunnel and open the browser to localhost:LOCAL_PORT"
    else
        local_port=$1
        remote_port=$2
        host=$3
        open http://localhost:$local_port
        echo "Tunneling '$host:$remote_port' to 'localhost:$local_port'..."
        ssh -N -L localhost:$local_port:localhost:$remote_port $host
    fi
}

# Display configuration for multiple monitors
###############################################################################
monitor-setup() {
    if [[ $# == 1 ]]; then
        direction=$1
    else
        direction=right
    fi
    xrandr --output eDP1 --auto --output DP1 --auto --primary --scale 1.8x1.8 --$direction-of eDP1
}
monitor-off() {
    xrandr --output eDP1 --auto --output DP1 --off
}
projector-setup() {
    if [[ $# == 1 ]]; then
        scale=$1
    else
        scale=1.67
    fi
    xrandr --output eDP1 --auto --primary --output DP1 --auto --scale ${scale}x${scale} --same-as eDP1
}


## Git
###############################################################################
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
###############################################################################


## Conda
###############################################################################
condaon() {
    export PATH=$CONDA_PREFIX/bin:$PATH
}

condaoff() {
    export PATH=`echo $PATH | sed -n -e 's@'"$CONDA_PREFIX"'/bin:@@p'`
}

conda-clean() {
    # Clean conda packages and the cache
    conda update --all && conda clean -pity
}

coff() {
    # Deactivate the conda environment
    conda deactivate
}

cenv() {
read -r -d '' CENV_HELP <<-'EOF'
Usage: cenv [COMMAND] [FILE]

Detect, activate, delete, and update conda environments.
FILE should be a conda .yml environment file.
If FILE is not given, assumes it is environment.yml.
Automatically finds the environment name from FILE.

Commands:

  None     Activates the environment
  rm       Delete the environment
  up       Update the environment

EOF
    envfile="environment.yml"
    if [[ $# -gt 2 ]]; then
        errcho "Invalid argument(s): $@";
        return 1;
    elif [[ $# == 0 ]]; then
        cmd="activate"
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "$CENV_HELP";
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
    elif [[ $# == 1 ]]; then
        envfile="$1"
        cmd="activate"
    else
        errcho "Invalid argument(s): $@";
        return 1;
    fi

    # Check if the file exists
    if [[ ! -e "$envfile" ]]; then
        errcho "Environment file not found:" $envfile;
        return 1;
    fi

    # Get the environment name from a conda yml file
    envname=$(grep "name: *" $envfile | sed -n -e 's/name: //p')

    if [[ $cmd == "activate" ]]; then
        conda activate "$envname";
    elif [[ $cmd == "update" ]]; then
        errcho "Updating environment:" $envname;
        conda activate "$envname";
        conda env update -f "$envfile"
    elif [[ $cmd == "delete" ]]; then
        errcho "Removing environment:" $envname;
        conda deactivate;
        conda env remove --name "$envname";
    fi
}
###############################################################################


## GMT
###############################################################################
gmttrunk(){
    export GMT_LIBRARY_PATH=$GMT_INSTALL_PREFIX/lib64
}

gmtconda() {
    unset GMT_LIBRARY_PATH
}

gmttest() {
    cd build; cmake --build . --target check; cd ..; alert
}

gmtdocs() {
    cd build
    cmake --build . --target docs_html
    cd ..
    alert
}


gmtdocs-full() {
    cd build
    cmake --build . --target docs_html_depends
    cmake --build . --target animation
    cmake --build . --target docs_html
    cd ..
    alert
}

gmtclean() {
    if [[ -e "$GMT_INSTALL_MANIFEST" ]]; then
        for f in $(cat $GMT_INSTALL_MANIFEST); do
            rm -rf "$f"
        done
        rm $GMT_INSTALL_MANIFEST
    else
        echo "Nothing to clean"
    fi
}

gmtbuild() {
    # Builds GMT and install to the prefix.
    # Needs to be run from the git repository.
    echo "Installing GMT from source to $GMT_INSTALL_PREFIX"
    echo "----------------------------------------------------"
    # Download coastline data if it's not yet present
    if [[ ! -d "$GMT_DATA_PREFIX" ]]; then
        echo "Downloading coastline data to $GMT_DATA_PREFIX"
        echo "----------------------------------------------------"
        mkdir $GMT_DATA_PREFIX
        # GSHHG (coastlines, rivers, and political boundaries):
        EXT="tar.gz"
        GSHHG="gshhg-gmt-2.3.6"
        URL="ftp://ftp.soest.hawaii.edu/gmt/$GSHHG.$EXT"
        curl $URL > $GSHHG.$EXT
        tar xzf $GSHHG.$EXT
        cp $GSHHG/* $GMT_DATA_PREFIX/
        rm -r $GSHHG $GSHHG.$EXT
        # DCW (country polygons):
        DCW="dcw-gmt-1.1.2"
        URL="ftp://ftp.soest.hawaii.edu/gmt/$DCW.$EXT"
        curl $URL > $DCW.$EXT
        tar xzf $DCW.$EXT
        cp $DCW/* $GMT_DATA_PREFIX
        rm -r $DCW $DCW.$EXT
    fi
    cp cmake/ConfigUserTemplate.cmake cmake/ConfigUser.cmake
    # Enable testing
    #echo "enable_testing()" >> cmake/ConfigUser.cmake
    #echo "set (DO_EXAMPLES TRUE)" >> cmake/ConfigUser.cmake
    #echo "set (DO_TESTS TRUE)" >> cmake/ConfigUser.cmake
    #echo "set (DO_ANIMATIONS TRUE)" >> cmake/ConfigUser.cmake
    #echo "set (DO_API_TESTS ON)" >> cmake/ConfigUser.cmake
    #echo "set (SUPPORT_EXEC_IN_BINARY_DIR TRUE)" >> cmake/ConfigUser.cmake
    #echo "set (GMT_USE_THREADS TRUE)" >> cmake/ConfigUser.cmake
    #echo "set (GMT_ENABLE_OPENMP TRUE)" >> cmake/ConfigUser.cmake
    #echo "set (CMAKE_C_FLAGS "-Wall -Wdeclaration-after-statement ${CMAKE_C_FLAGS}")" >> cmake/ConfigUser.cmake
    # Clean the build dir
    #if [[ -d build ]]; then
        #rm -r build
    #fi
    mkdir -p build && cd build
    echo ""
    echo "Running cmake"
    echo "----------------------------------------------------"
    cmake \
        -D CMAKE_INSTALL_PREFIX=$GMT_INSTALL_PREFIX \
        -D GDAL_ROOT=$CONDA_PREFIX \
        -D NETCDF_ROOT=$CONDA_PREFIX \
        -D PCRE_ROOT=$CONDA_PREFIX \
        -D FFTW3_ROOT=$CONDA_PREFIX \
        -D ZLIB_ROOT=$CONDA_PREFIX \
        -D CURL_ROOT=$CONDA_PREFIX \
        -D DCW_ROOT=$GMT_DATA_PREFIX \
        -D GSHHG_ROOT=$GMT_DATA_PREFIX \
        -D GMT_INSTALL_MODULE_LINKS:BOOL=FALSE \
        ..
    echo ""
    echo "Build and install"
    echo "----------------------------------------------------"
    cmake --build . && cmake --build . --target install \
        && cp install_manifest.txt $GMT_INSTALL_MANIFEST
    cd ..
    echo "Done"
    alert
}
###############################################################################


## Edit PDFs (remove fonts, RGB to CMYK)
###############################################################################
pdf2ps-nofonts() {
    # Convert pdfs to ps with fonts converted to paths for editing in Inkscape
    # Call it as: pdf2ps-nofonts INPUT.pdf OUTPUT.ps
    # Based on the answer to this StackOverlow question:
    # http://stackoverflow.com/questions/7131670/make-bash-alias-that-takes-parameter
    # and this Ubuntu Forums question:
    # http://ubuntuforums.org/showthread.php?t=1781049
    gs -sDEVICE=ps2write -dNOCACHE -sOutputFile=$2 -q -dbatch -dNOPAUSE $1 -c quit
}

pdfcmyk() {
    # Convert a PDF from RGB to CMYK
    # Call it as: pdfcmyk INPUT.pdf OUTPUT.pdf
    # Based on http://zeroset.mnim.org/2014/07/14/save-a-pdf-to-cmyk-with-inkscape/
    gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite \
        -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
        -sOutputFile=$2 $1
}
###############################################################################


## DOCKER
###############################################################################
dockerclean() {
    docker system prune -a -f;
    docker rm -v $(sudo docker ps -a -q -f status=exited);
    docker rmi -f  $(sudo docker images -f "dangling=true" -q);
    docker volume ls -qf dangling=true | xargs -r docker volume rm;
}
###############################################################################
