# This is OSX-specific stuff

source ~/.bashrc

# This has to be here, because reasons
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export PS1="\w $ "
