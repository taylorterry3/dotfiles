#!/bin/bash

echo "Adding deb repos"

echo "Adding PPAs"

echo "updating repositories"
sudo apt update

echo "Installing packages"

# strictly needed for a python data science environment
sudo apt install build-essential cython gcc gfortran libbz2-dev libffi-dev libfreetype6-dev liblapack-dev liblzma-dev libopenblas-dev libreadline-dev libsqlite3-dev libssl-dev postgresql-client python3-dev zlib1g-dev

# other stuff
sudo apt install golang htop screen xclip

echo "Finished adding PPAs and installing applications"

echo "Setting up pyenv"

# Python setup
# If re-running after an error you'll need to `rm -rf ~/.pyenv`
curl https://pyenv.run | bash
eval "$(pyenv init -)"
pyenv update
pyenv install 3.8.0
pyenv global 3.8.0

pip install --upgrade pip
pip install awscli


exit 0
