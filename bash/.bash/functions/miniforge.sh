# Install Miniforge

install-miniforge() {
read -r -d '' MINIFORGEDOWNLOAD_HELP <<-'EOF'
Usage: install-miniforge

Download Miniforge from GitHub and install it to ~/bin
https://github.com/conda-forge/miniforge

EOF
    if [[ $# -ne 0 ]]; then
        echo "$MINIFORGEDOWNLOAD_HELP"
        return 1;
    fi
    outdir="$HOME/bin"
    fname="Miniforge3-Linux-x86_64.sh"
    baseurl="https://github.com/conda-forge/miniforge/releases/latest/download"
    wget -P $outdir $baseurl/$fname \
        && bash $outdir/$fname -b -p $outdir/miniforge3 \
        && rm $outdir/$fname
}
