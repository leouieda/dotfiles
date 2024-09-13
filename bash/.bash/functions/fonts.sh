# Dowload and install Nerd Fonts https://www.nerdfonts.com

nerdfonts() {
    if [[ $# -le 0 ]]; then
        echo "Usage: nerdfonts FontName"
        echo ""
        echo "The name should be the package in the nerdfonts release page: https://github.com/ryanoasis/nerd-fonts/releases/latest"
    else
        wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$1.zip \
        && cd ~/.local/share/fonts \
        && unzip $1.zip \
        && rm $1.zip \
        && fc-cache -fv
        cd -
    fi
}
