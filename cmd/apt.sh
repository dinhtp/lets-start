#!/bin/bash

echo "=======Installing PHP Storm======="
sudo snap install phpstorm --channel=2020.3/stable --classic

echo "=======Installing Go Land======="
sudo snap install goland --channel=2020.2/stable --classic

echo "=======Installing Postman======="
sudo snap install postman --classic

echo "=======Installing VLC======="
sudo snap install vlc --classic

echo "=======Installing Drawio======="
sudo snap install drawio --classic

echo "=======Installing VsCode======="
sudo snap install --classic code

echo "=======Installing Skype======="
sudo wget https://go.skype.com/skypeforlinux-64.deb
sudo apt install ./skypeforlinux-64.deb
sudo apt update

echo "=======Installing Filezilla======="
sudo apt-get update
sudo apt-get install filezilla

echo "=======Installing Sublime Text======="
sudo apt update
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt install sublime-text

echo "=======Installing Unikey======="
sudo add-apt-repository ppa:ubuntu-vn/ppa
sudo apt-get update
sudo apt-get install ibus-unikey
ibus restart

echo "=======Installing Mysql Workbench======="
wget https://repo.mysql.com//mysql-apt-config_0.8.16-1_all.deb
sudo apt install ./mysql-apt-config_0.8.16-1_all.deb
sudo apt update
sudo apt install mysql-workbench-community

echo "=======Installing Shutter======="
sudo add-apt-repository -y ppa:linuxuprising/shutter
sudo apt update
sudo apt install shutter
wget https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas-common_1.0.0-1_all.deb
wget https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas3_1.0.0-1_amd64.deb
wget https://launchpad.net/ubuntu/+archive/primary/+files/libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb
sudo dpkg -i libgoocanvas-common_1.0.0-1_all.deb
sudo dpkg -i libgoocanvas3_1.0.0-1_amd64.deb
sudo dpkg -i libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb
sudo apt -f install
sudo killall shutter

echo "=======Installing Git======="
sudo apt-get update
sudo apt install git-all

echo "=======Installing GNOME Tweak Tool======="
sudo add-apt-repository universe
sudo apt-get update
sudo apt install gnome-tweak-tool

echo "=======Installing Font Manager======="
sudo apt install font-manager

echo "=======Installing GNOME System Monitor Extension======="
sudo apt-get install gnome-shell-extension-system-monitor

echo "=======Installing Make======="
sudo apt install make

echo "=======Installing Cobra======="
sudo apt install cobra

echo "=======Installing PHP 7.4======="
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php7.4 php7.4-fpm
sudo apt install php7.4-mysql php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl php7.4-xmlwriter
