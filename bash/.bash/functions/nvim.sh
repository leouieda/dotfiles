# Install Neovim using the AppImage to get the latest version

install-nvim() {
read -r -d '' NERDFONTS_HELP <<-'EOF'
Usage: install_nvim

Install the Neovim AppImage to ~/bin and make it executable.

EOF
    if [[ $# -ne 0 ]]; then
        echo "$NERDFONTS_HELP"
        return 1;
    fi
    app="nvim.appimage"
    outdir="$HOME/bin"
    baseurl="https://github.com/neovim/neovim/releases/latest/download"
    wget -P $outdir $baseurl/$app && chmod u+x $outdir/$app
}
