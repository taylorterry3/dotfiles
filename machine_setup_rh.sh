#!/bin/bash

# this is very much WIP

echo "updating repositories"
# sudo apt update

echo "Installing packages"

# strictly needed for a python data science environment
sudo yum install libpng-devel

# pyodbc dependency
sudo yum install unixODBC-devel

# needed for R
sudo yum install libffi-devel openssl-devel

sudo yum install cairo-devel libcurl-devel libX11-devel libXt-devel readline-devel

# other stuff
sudo yum install jq

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
# cd
# wget https://download1.rstudio.org/desktop/debian9/x86_64/rstudio-1.2.5001-amd64.deb
# sudo dpkg -i rstudio-1.2.5001-amd64.deb 

exit 0
