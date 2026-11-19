# export PROMPT=''

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
setopt APPEND_HISTORY

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias pag='ps aux | grep'
alias drive='cd ~/Google\ Drive'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# header function
alias header='head -1 | tr "\t" "\n" | nl'

# Private content
source ~/.zshrc_private

# Open VS Code with a profile isolated per client under ~/projects/<client>/.
code() {
    local target="${1:-.}"
    local target_path="${target:A}"
    local projects_root="${HOME}/projects"
    local client_path client client_root

    # For option-only calls such as `code -n`, use the current directory.
    [[ "$target" == -* ]] && target_path="${PWD:A}"
    projects_root="${projects_root:A}"
    client_path="${target_path#$projects_root/}"
    if [[ "$client_path" != "$target_path" && "$client_path" == */* ]]; then
        client="${client_path%%/*}"
        client_root="$HOME/.vscode-clients/$client"

        mkdir -p "$client_root/vscode-data" "$client_root/codex-home" || return 1
        CODEX_HOME="$client_root/codex-home" command code \
            --user-data-dir "$client_root/vscode-data" \
            --extensions-dir "$HOME/.vscode/extensions" \
            "$@"
        return
    fi

    command code "$@"
}

# Create a client-scoped Git worktree and open it in VS Code.
wt-new() {
    if (( $# < 1 || $# > 2 )); then
        print -u2 "Usage: wt-new <branch-name> [base-branch]"
        return 2
    fi

    local branch_name="$1"
    local base_branch="${2:-main}"
    local repo_root main_repo repo_name repo_parent client_dir
    local base_ref="$base_branch"
    local safe_branch wt_path env_file

    repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
        print -u2 "wt-new: not inside a Git repository"
        return 1
    }
    main_repo=$(git -C "$repo_root" worktree list --porcelain |
        awk '/^worktree / { print substr($0, 10); exit }') || return 1

    repo_name="${main_repo:t}"
    repo_parent="${repo_root:h}"
    if [[ "${repo_parent:t}" == "worktrees" ]]; then
        client_dir="${repo_parent:h}"
    else
        client_dir="$repo_parent"
    fi

    if git -C "$main_repo" remote get-url origin >/dev/null 2>&1; then
        if git -C "$main_repo" fetch origin "$base_branch"; then
            base_ref="origin/$base_branch"
        elif git -C "$main_repo" rev-parse --verify --quiet "$base_branch^{commit}" >/dev/null; then
            print -u2 "wt-new: could not fetch origin/$base_branch; using local $base_branch"
        else
            print -u2 "wt-new: base branch '$base_branch' was not found locally or on origin"
            return 1
        fi
    fi
    git -C "$main_repo" rev-parse --verify --quiet "$base_ref^{commit}" >/dev/null || {
        print -u2 "wt-new: base branch '$base_branch' was not found"
        return 1
    }

    safe_branch="${branch_name//\//-}"
    wt_path="$client_dir/worktrees/$repo_name-$safe_branch"
    mkdir -p "$client_dir/worktrees" || return 1
    git -C "$main_repo" branch --no-track "$branch_name" "$base_ref" || return 1
    if ! git -C "$main_repo" worktree add "$wt_path" "$branch_name"; then
        git -C "$main_repo" branch -D -- "$branch_name" >/dev/null 2>&1
        return 1
    fi

    while IFS= read -r env_file; do
        [[ "$env_file" == */* || "$env_file" == ".env.example" ]] && continue
        [[ -f "$main_repo/$env_file" ]] || continue
        cp -p "$main_repo/$env_file" "$wt_path/$env_file" || return 1
    done < <(
        git -C "$main_repo" ls-files --others --exclude-standard -- '.env*'
        git -C "$main_repo" ls-files --others --ignored --exclude-standard -- '.env*'
    )

    code "$wt_path"
}

# Remove a worktree and its local branch.
wt-rm() {
    local force=0
    local target_path branch_name main_repo current_path

    if [[ "$1" == "-f" ]]; then
        force=1
        shift
    fi

    if (( $# > 1 )); then
        print -u2 "Usage: wt-rm [-f] [worktree-path]"
        return 2
    fi

    if (( $# == 1 )); then
        target_path=$(git -C "$1" rev-parse --show-toplevel 2>/dev/null) || {
            print -u2 "wt-rm: '$1' is not inside a Git worktree"
            return 1
        }
    else
        target_path=$(git rev-parse --show-toplevel 2>/dev/null) || {
            print -u2 "wt-rm: not inside a Git repository"
            return 1
        }
    fi

    if [[ "$target_path" != */worktrees/* ]]; then
        print -u2 "wt-rm: target must be inside a worktrees directory"
        return 1
    fi

    branch_name=$(git -C "$target_path" branch --show-current) || return 1
    [[ -n "$branch_name" ]] || {
        print -u2 "wt-rm: target worktree is in detached HEAD state"
        return 1
    }
    main_repo=$(git -C "$target_path" worktree list --porcelain |
        awk '/^worktree / { print substr($0, 10); exit }') || return 1

    [[ "$target_path" != "$main_repo" ]] || {
        print -u2 "wt-rm: refusing to remove the main worktree"
        return 1
    }

    current_path="${PWD:A}"
    if [[ "$current_path" == "$target_path" || "$current_path" == "$target_path/"* ]]; then
        builtin cd -- "$main_repo" || return 1
    fi

    if (( force )); then
        git -C "$main_repo" worktree remove --force "$target_path" || return 1
    else
        if ! git -C "$main_repo" merge-base --is-ancestor "$branch_name" HEAD; then
            print -u2 "wt-rm: branch '$branch_name' is not merged into the main checkout; use wt-rm -f to override"
            return 1
        fi
        if ! git -C "$main_repo" worktree remove "$target_path"; then
            print -u2 "wt-rm: worktree was not removed (it may contain uncommitted or untracked files); inspect it or use wt-rm -f to override"
            return 1
        fi
    fi
    git -C "$main_repo" worktree prune || return 1
    if (( force )); then
        git -C "$main_repo" branch -D -- "$branch_name"
    else
        git -C "$main_repo" branch -d -- "$branch_name"
    fi
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Homebrew/cask will put stuff in dumb places if you don't do this
export HOMEBREW_CASK_OPTS="--appdir=/Applications"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# R
# export PATH="$HOME/.Renv/bin:$PATH"
# if which Renv > /dev/null; then eval "$(Renv init -)"; fi

# Go
export GOPATH=$HOME/go
# export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# Docker
alias dclear='docker ps -a -q | xargs docker rm'
alias dlastlog='docker ps -q | sed -n "2p" | xargs docker logs'
# alias dnuke='docker ps -a -q | grep -v consul | xargs docker rm -f' # useful, but dangerous
alias dps='docker ps --format "table {{.ID}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Names}}"'
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/mambaforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/taylorterry/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/taylorterry/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/taylorterry/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/taylorterry/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/google-cloud-sdk/bin:$PATH"

export DYLD_LIBRARY_PATH="/opt/homebrew/opt/gdal/lib:$DYLD_LIBRARY_PATH"
export PATH="$HOME/.local/bin:$PATH"
