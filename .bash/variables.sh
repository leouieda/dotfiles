# Enviornment variable definitions

export PATH=$HOME/bin:$PATH
export PATH=$HOME/pkg/bin:$PATH
export PATH=$HOME/bin/zotero:$PATH
export PATH=$HOME/src/tesseroids/bin:$PATH
export PATH=$HOME/.gem/ruby/2.5.0/bin:$PATH

export CONDA_PREFIX=$HOME/miniconda3

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lib

export GMT_INSTALL_PREFIX=$HOME/pkg
export GMT_INSTALL_MANIFEST=$GMT_INSTALL_PREFIX/gmt_install_manifest.txt
export GMT_DATA_PREFIX=$GMT_INSTALL_PREFIX/share/coast

# To make JabRef fonts not horrible
# http://crunchbang.org/forums/viewtopic.php?pid=248580#p248580
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
