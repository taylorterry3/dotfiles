#!/bin/bash
# Stuff that this doesn't do:
# Git and xclip, as well as github key setup
# Anaconda (wget the current Python 3.x .sh, something like http://repo.continuum.io/anaconda3/Anaconda3-2.1.0-Linux-x86_64.sh, and run it)
# Then export PATH=~/anaconda3/bin:$PATH
# Ruby setup with rbenv: https://gorails.com/setup/ubuntu/14.04
# R's devtools mess
# Rstudio
# Revolution R's optimized R distro
# Put this line in .profile for RRO:
# export RSTUDIO_WHICH_R=/usr/lib64/RRO-8.0/R-3.1.1/bin/R

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
add-apt-repository ppa:git-core/ppa -y

echo "updating repositories"
apt-get update

echo "Installing packages"
apt-get install build-essential curl docker.io fluxgui git-core golang google-chrome-stable julia libapparmor1 libcurl4-openssl-dev libjpeg62 libmysqlclient-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxslt1-dev libyaml-dev lm-sensors mercurial mysql-server mysql-common mysql-client openjdk-7-jdk openvpn pgadmin3 postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3 python-bs4 python-software-properties qgis r-base rbenv ruby ruby-build ruby-dev spotify-client-qt sqlite3 tmux vim zlib1g-dev

echo "Finished adding PPAs and installing applications"
exit 0
