# Automate building and developing GMT

export GMT_INSTALL_PREFIX=$HOME/pkg
export GMT_INSTALL_MANIFEST=$GMT_INSTALL_PREFIX/gmt_install_manifest.txt
export GMT_DATA_PREFIX=$GMT_INSTALL_PREFIX/coast
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lib64

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

