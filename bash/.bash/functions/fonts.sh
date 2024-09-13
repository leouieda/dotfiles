# Dowload and install Nerd Fonts https://www.nerdfonts.com

nerdfonts() {
read -r -d '' NERDFONTS_HELP <<-'EOF'
Usage: nerdfonts FontName

Download a Nerd Font and install it locally.

The FontName should be the package in the nerdfonts release page:
https://github.com/ryanoasis/nerd-fonts/releases/latest

EOF
    if [[ $# -ne 1 ]]; then
        echo "$NERDFONTS_HELP"
        return 1;
    fi
    outdir="$HOME/.local/share/fonts/$1"
    baseurl="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
    wget -P $outdir $baseurl/$1.zip \
        && unzip $outdir/$1.zip -d $outdir \
        && rm $outdir/$1.zip \
        && fc-cache -fv
}
