#!/bin/bash
# Stuff that this doesn't do:
# Git and xclip, as well as github key setup
# Anaconda (wget the current Python 3.x .sh, something like http://repo.continuum.io/anaconda3/Anaconda3-2.0.1-Linux-x86_64.sh, and run it)
# R's devtools mess
# Rstudio
# Revolution R's optimized R distro

# Uncomment the remaining libraries in sources.list
sudo sed 's/# deb/deb/' -i /etc/apt/sources.list

echo "Adding keys"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4E9CFF4E
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

echo "Adding deb repos"
# Comment these out after first run so as not to spam sources.list
echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

echo "Manually downloading some installers\nBe careful, there is hardcoding to tterry here"

mkdir -p ~/.vim/autoload ~/.vim/bundle
chown -R ~/.vim tterry
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "Adding PPAs"
add-apt-repository ppa:marutter/rrutter -y
add-apt-repository ppa:ubuntugis/ubuntugis-stable -y
add-apt-repository ppa:kilian/f.lux -y
add-apt-repository 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' -y
add-apt-repository ppa:staticfloat/juliareleases -y

echo "updating repositories"
apt-get update

echo "Installing packages"
apt-get install r-base qgis postgresql-9.3 postgresql-contrib-9.3 pgadmin3 spotify-client-qt google-chrome-stable openvpn fluxgui tmux julia vim curl libapparmor1 ruby ruby-dev sqlite3 libsqlite3-dev libjpeg62

echo "Finished adding PPAs and installing applications"
exit 0
