#!/bin/bash
# Stuff that this doesn't do:
# Git and xclip, as well as github key setup
# Anaconda (wget the current Python 3.x .sh, something like http://repo.continuum.io/anaconda3/Anaconda3-2.1.0-Linux-x86_64.sh, and run it)
# Then export PATH=~/anaconda3/bin:$PATH
# Ruby setup with rbenv: https://gorails.com/setup/ubuntu/14.04
# R's devtools mess
# OpenVPN
# Revolution R's optimized R distro
# Put this line in .profile for RRO:
# export RSTUDIO_WHICH_R=/usr/lib64/RRO-8.0/R-3.1.1/bin/R

echo "Installing packages"
# I need to stop acting like a neckbeard and move this all to a brewfile

brew install brew-cask
brew tap caskroom/cask

# command line tools
brew install cmake curl hub tmux wget
brew install gnu-sed --with-default-names 

# creature comforts
brew cask install flux sonos

# Python (needs work)
# brew cask install python-bs4 python-software-properties

# R stuff. I use RRO so there is no R install here. May need to do that first since rstudio looks for R at /usr/bin/R and may hork if it's not there
brew cask install rstudio

# Ruby (needs work)
brew install ruby-build # rbenv ruby-dev

# Other languages
brew install hg go # Go uses mercurial, not 100% sure hg is necessary but whatevs
brew cask install java julia

# SQL/DBs
# mysql-server mysql-common mysql-client postgresql-9.4 postgresql-contrib-9.4 postgresql-server-dev-9.4 pgadmin3 
brew install mongo mysql mysqlworkbench postgresql robomongo # this is kind of busted
brew cask install dbeaver-community

# Editors and such
brew cask install atom basictex textwrangler

# Plumbing
brew cask install nomachine ssh-tunnel-manager tunnelblick

# Random
brew install docker maven
brew cask install data-integration paintbrush qgis slack tableau


# Cleanup
brew update && brew upgrade brew-cask && brew cleanup

echo "Finished adding PPAs and installing applications"

echo "Manually downloading some installers"

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle
git clone git://github.com/croaky/vim-colors-github.git ~/.vim/bundle

exit 0
