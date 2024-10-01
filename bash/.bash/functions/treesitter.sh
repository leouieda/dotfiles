# Download and install tree-sitter for better syntax highlighting

install-tree-sitter() {
read -r -d '' TREESITTERDOWNLOAD_HELP <<-'EOF'
Usage: install-tree-sitter

Download tree-sitter-cli from GitHub and install it to ~/bin
https://github.com/tree-sitter/tree-sitter/releases

EOF
    if [[ $# -ne 0 ]]; then
        echo "$TREESITTERDOWNLOAD_HELP"
        return 1;
    fi
    outdir="$HOME/bin"
    fname="tree-sitter-linux-x64.gz"
    baseurl="https://github.com/tree-sitter/tree-sitter/releases/latest/download"
    wget -P $outdir $baseurl/$fname \
        && gzip --decompress $outdir/$fname \
        && mv $outdir/tree-sitter-linux-x64 $outdir/tree-sitter \
        && chmod u+x $outdir/tree-sitter
}
