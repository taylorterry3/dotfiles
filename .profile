# Top-level file that only exists because of the sourcing order of various OS'es
# Only runs in bash

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

source ~/.bashrc

export PS1="\w $ "
