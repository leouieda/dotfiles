#!/bin/bash

DEV="git vim meld"
VIS="gimp inkcape shutter"
TXT="texlive-full libreoffice-impress"
MISC="gnome-do xclip"

sudo apt-get install -y $DEV
sudo apt-get install -y $MISC
sudo apt-get install -y $VIS
sudo apt-get install -y $TXT
