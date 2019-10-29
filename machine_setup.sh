#!/bin/bash

echo "Adding deb repos"

echo "Adding PPAs"

echo "updating repositories"
sudo apt update

echo "Installing packages"

# strictly needed for a python data science environment
sudo apt install build-essential cython gcc gfortran libbz2-dev libffi-dev libfreetype6-dev liblapack-dev liblzma-dev libopenblas-dev libreadline-dev libsqlite3-dev libssl-dev postgresql-client python3-dev zlib1g-dev

# needed for R
sudo apt install libclang-dev libcurl4-openssl-dev libxt-dev libx11-dev

# other stuff
sudo apt install golang htop screen xclip

echo "Finished adding PPAs and installing applications"

echo "Setting up Python"

# Python setup
# If re-running after an error you'll need to `rm -rf ~/.pyenv`
curl https://pyenv.run | bash
eval "$(pyenv init -)"
pyenv update
pyenv install 3.8.0
pyenv global 3.8.0

pip install --upgrade pip
pip install awscli

echo "Setting up R"

# R Setup
# from https://github.com/viking/Renv#section_2
# and https://github.com/viking/R-build
cd
git clone git://github.com/viking/Renv.git .Renv
eval "$(Renv init -)"
mkdir -p ~/.Renv/plugins
cd ~/.Renv/plugins
git clone git://github.com/viking/R-build.git
Renv install 3.6.1
Renv global 3.6.1

wget https://download1.rstudio.org/desktop/debian9/x86_64/rstudio-1.2.5001-amd64.deb
sudo dpkg -i rstudio-1.2.5001-amd64.deb 

exit 0
