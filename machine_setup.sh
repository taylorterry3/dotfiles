#!/bin/bash

echo "Adding deb repos"

echo "Adding PPAs"

echo "updating repositories"
sudo apt update

echo "Installing packages"
sudo apt install build-essential gcc golang libbz2-dev libffi-dev libreadline-dev libsqlite3-dev libssl-dev postgresql-client screen xclip zlib1g-dev

echo "Finished adding PPAs and installing applications"

echo "Setting up pyenv"

curl https://pyenv.run | bash
exec $SHELL
pyenv update

exit 0
