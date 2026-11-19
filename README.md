dotfiles
========

These are my dotfiles. There are many like them, but these are mine.

All the usual suspects are here, along with machine_setup.sh for setting up a standard workstation on Ubuntu and machine_setup_osx.sh for doing the same via homebrew on OSX. Most of this works with cygwin as well.

Caveat praedor: I generally push small changes straight to main.

Note the dependency on .bashrc_private, which needs to be copied in by hand. That's where I keep semi-sensitive stuff like server aliases.

## Zsh VS Code profiles and Git worktrees

`make_links.sh` symlinks this repository's `.zshrc` to `~/.zshrc`. The `code`
function in that file gives each client an isolated VS Code profile when the
opened path is under:

    ~/projects/<client>/<repo>

Its VS Code data and Codex home are stored in
`~/.vscode-clients/<client>/`. Projects outside `~/projects/<client>/` use the
normal VS Code CLI unchanged. Client profiles intentionally have separate VS
Code settings, keybindings, snippets, extension state, and Codex sign-in.

Create a worktree and a new branch with:

    wt-new <branch-name> [base-branch]

The base branch defaults to `main`; if `origin` exists, it is fetched first. If
that branch exists only locally, the local branch is used instead.
Worktrees are created at
`~/projects/<client>/worktrees/<repo>-<branch>`. Untracked root-level `.env*`
files are copied into the worktree, except `.env.example`.

For repositories outside `~/projects/<client>/`, `wt-new` uses the repository's
parent directory for the worktree location and opens it with the normal VS Code
profile.

Remove a worktree from inside it, or pass its path explicitly:

    wt-rm [-f] [worktree-path]

Without `-f`, this refuses to remove a dirty worktree or a branch not merged
into the main checkout. Use `-f` only when you deliberately want to discard
worktree changes and delete an unmerged branch. On success, it prunes stale
worktree metadata and deletes the local branch.

Reload after installing the change:

    source ~/.zshrc

