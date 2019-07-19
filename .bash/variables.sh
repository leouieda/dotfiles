# Enviornment variable definitions

# Include the PATH definitions
if [ -f $HOME/.bash/path.sh ]; then
    source $HOME/.bash/path.sh
fi

export EDITOR=vim

export CONDA_PREFIX=$HOME/miniconda3

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lib64

export GMT_INSTALL_PREFIX=$HOME/pkg
export GMT_INSTALL_MANIFEST=$GMT_INSTALL_PREFIX/gmt_install_manifest.txt
export GMT_DATA_PREFIX=$GMT_INSTALL_PREFIX/coast

# To make JabRef fonts not horrible
# http://crunchbang.org/forums/viewtopic.php?pid=248580#p248580
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"

# Limit the maximum number of openmp threads so that I can still use multiprocessing
export OMP_NUM_THREADS=4
