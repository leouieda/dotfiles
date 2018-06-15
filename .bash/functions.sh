# Useful bash functions

## Conda
###############################################################################
condaon() {
    export PATH=$CONDA_PREFIX/bin:$PATH
}

condaoff() {
    export PATH=`echo $PATH | sed -n -e 's@'"$CONDA_PREFIX"'/bin:@@p'`
}

condaclean() {
    # Clean conda packages and the cache
    conda update --all && conda clean -pity
}

coff() {
    # Deactivate the conda environment
    source deactivate
}

get_conda_env_name() {
    # Get the environment name from a conda yml file
    grep "name: *" $1 | sed -n -e 's/name: //p'
}

cenv() {
    # Activate and delete conda environments using the yml files.
    # Finds the env name from the environment file (given or assumes environment.yml in
    # current directory).
    # Usage:
    #   1. Activate using the environment.yml in the current directory:
    #      $ cenv
    #   2. Activate using the given enviroment file:
    #      $ cenv my_env_file.yml
    #   3. Delete an environment using the given file (deactivates environments first):
    #      $ cenv rm my_env_file.yml

    if [ $# == 0 ]; then
        envfile="environment.yml"
        cmd="activate"
    elif [ $# == 1 ]; then
        envfile="$1"
        cmd="activate"
    elif [ $# == 2 ] && [ "$1" == "rm" ]; then
        envfile="$2"
        cmd="delete"
    else
        errcho "Invalid argument(s): $@";
        return 1;
    fi

    # Check if the file exists
    if [ ! -e "$envfile" ]; then
        errcho "Environment file not found:" $envfile;
        return 1;
    fi

    envname=$(get_conda_env_name $envfile)

    if [ $cmd == "activate"]; then
        source activate "$envname";
    elif [ $cmd == "delete" ]; then
        errcho "Removing environment:" $envname;
        coff;
        conda env remove --name "$envname";
    fi
}
###############################################################################


## GMT
###############################################################################

gmttest() {
    make -C build check; alert
}

gmtclean() {
    for f in $(cat $GMT_INSTALL_MANIFEST); do
        rm -rf "$f"
    done
    rm $GMT_INSTALL_MANIFEST
}

gmtbuild() {
    # Builds GMT and install to the prefix.
    # Needs to be run from the SVN repository.
    if [[ -e "$GMT_INSTALL_MANIFEST" ]]; then
        echo "Cleaning previous install"
        echo "----------------------------------------------------"
        gmtclean
        echo ""
    fi
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
    # cmake is ignoring this option
    echo "enable_testing()" >> cmake/ConfigUser.cmake
    echo "set (DO_EXAMPLES TRUE)" >> cmake/ConfigUser.cmake
    echo "set (DO_TESTS TRUE)" >> cmake/ConfigUser.cmake
    echo "set (N_TEST_JOBS `nproc`)" >> cmake/ConfigUser.cmake
    #set (CMAKE_BUILD_TYPE Debug)
    echo "add_definitions(-DDEBUG)" >> cmake/ConfigUser.cmake
    #set (CMAKE_C_FLAGS "-Wall -Wdeclaration-after-statement") # recommended even for release build
    #set (CMAKE_C_FLAGS "-Wextra ${CMAKE_C_FLAGS}")            # extra warnings
    # gdb debugging symbols
    echo "set (CMAKE_C_FLAGS_DEBUG -ggdb3)" >> cmake/ConfigUser.cmake
    #set (CMAKE_LINK_DEPENDS_DEBUG_MODE TRUE)                  # debug link dependencies
    # Clean the build dir
    if [[ -d build ]]; then
        rm -r build
    fi
    mkdir -p build && cd build
    echo ""
    echo "Running cmake"
    echo "----------------------------------------------------"
    cmake -D CMAKE_INSTALL_PREFIX=$GMT_INSTALL_PREFIX \
          -D GDAL_ROOT=$CONDA_PREFIX \
          -D NETCDF_ROOT=$CONDA_PREFIX \
          -D PCRE_ROOT=$CONDA_PREFIX \
          -D FFTW3_ROOT=$CONDA_PREFIX \
          -D ZLIB_ROOT=$CONDA_PREFIX \
          -D DCW_ROOT=$GMT_DATA_PREFIX \
          -D GSHHG_ROOT=$GMT_DATA_PREFIX \
          -D GMT_INSTALL_MODULE_LINKS:BOOL=FALSE \
          -D CMAKE_BUILD_TYPE=Debug \
          ..
    echo ""
    echo "Build and install"
    echo "----------------------------------------------------"
    make -j`nproc` && make install
    cp install_manifest.txt $GMT_INSTALL_MANIFEST
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
