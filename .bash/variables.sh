# Enviornment variable definitions

# Include the PATH definitions
if [ -f $HOME/.bash/path.sh ]; then
    source $HOME/.bash/path.sh
fi

export EDITOR=vim

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lib64

export GMT_INSTALL_PREFIX=$HOME/pkg
export GMT_INSTALL_MANIFEST=$GMT_INSTALL_PREFIX/gmt_install_manifest.txt
export GMT_DATA_PREFIX=$GMT_INSTALL_PREFIX/coast

# To make JabRef fonts not horrible
# http://crunchbang.org/forums/viewtopic.php?pid=248580#p248580
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
