# Download and install tree-sitter for better syntax highlighting

tree-sitter-download() {
read -r -d '' TREESITTERDOWNLOAD_HELP <<-'EOF'
Usage: tree-sitter-download

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
        && chmod u+x $outdir/$fname
}