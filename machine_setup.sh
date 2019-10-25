#!/bin/bash

echo "Adding deb repos"

echo "Adding PPAs"

echo "updating repositories"
sudo apt update

echo "Installing packages"

# strictly needed for a python data science environment
sudo apt install build-essential gcc libbz2-dev libffi-dev libreadline-dev libsqlite3-dev libssl-dev postgresql-client zlib1g-dev

# other stuff
sudo apt install golang screen xclip

echo "Finished adding PPAs and installing applications"

echo "Setting up pyenv"

curl https://pyenv.run | bash
exec $SHELL
pyenv update

exit 0
