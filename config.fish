if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Aliases
alias l='ls -lah'
alias ll='ls -l'
alias la='ls -a'
alias cat="ccat"

alias -s gz='tar -xzvf' >/dev/null
alias -s tgz='tar -xzvf' >/dev/null
alias -s zip='unzip' >/dev/null
alias -s bz2='tar -xjvf' >/dev/null
alias -s jar='java -jar' >/dev/null
alias -s md='open -a /Applications/Typora.app' >/dev/null

# Git Aliases

# Go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs="git status"
alias gp="git push"
alias gpoh="git push -u origin HEAD"
alias gpmy="git push -u sxzz"
alias gpf="git push --force"
alias gpft="git push --follow-tags"
alias gpdo="git push --delete origin"
alias gpl="git pull --rebase"
alias gcl="git clone"
alias gst="git stash"
alias gstp="git stash pop"
alias grm='git rm'
alias gmv='git mv'

alias gco="git checkout"
alias main='git checkout main'
alias gcd="git checkout dev"

alias gb="git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"

alias grb="git rebase"
alias grbom="git rebase origin/main"
alias grbod="git rebase origin/dev"
alias grbum="git rebase upstream/main"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"

alias gl="git log"
alias glo="git log --oneline --graph"

alias grsH="git reset HEAD"
alias grsH1="git reset HEAD~1"
alias grsh="git reset --hard"
alias grshod="git reset --hard origin/dev"
alias grshom="git reset --hard origin/main"

alias ga="git add"
alias gA="git add -A"

alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit -a"
alias gcae="git commit --amend"
alias gcam="git add -A && git commit -m"
alias gfrb="git fetch origin && git rebase origin/main"
alias gsha="git rev-parse HEAD | pbcopy"

alias gxn='git clean -dn'
alias gx='git clean -df'

# GitHub Aliases
alias ghci='gh run list -L 1'
alias pr="gh pr checkout"
alias fork="gh repo fork"

# NPM Aliases
alias s="nr start"
alias d="nr --silent dev"
alias b="nr build"
alias t="nr test"
alias tu="nr test -u"
alias tw="nr test --watch"
alias lint="nr lint"
alias lintf="nr lint --fix"
alias re="nr release"
alias nio="ni --prefer-offline"
alias u="nu"
alias ui="nu -i"
alias uli="nu --latest -i"

# @sxzz/create
alias cr='create'

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias coder="code -r ."

function gbp
    git remote prune origin
    set GONE_BRANCHES (git branch -v | grep "\[gone\]" | awk '{print $1}')
    echo \n\nDelete branches:
    echo $GONE_BRANCHES

    read -l -P 'Do you want to continue? [Y/n] ' confirm
    switch $confirm
        case N n
            echo Aborted
            return 1
    end
    echo $GONE_BRANCHES | xargs git branch -D
end

# proxy
function proxy
    set -gx https_proxy http://127.0.0.1:6152
    set -gx http_proxy http://127.0.0.1:6152
    set -gx all_proxy socks5://127.0.0.1:6153
end
function unproxy
    set -gu http_proxy
    set -gu https_proxy
    set -gu all_proxy
end
function ssh_proxy
    ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:6152 %h %p" $argv
end
function proxy_charles
    set -gx https_proxy http://127.0.0.1:8888
    set -gx http_proxy http://127.0.0.1:8888
end

# Environment Variables
# fish_add_path /usr/local/sbin

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin

# 1Passsword SSH
set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock

# Golang
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# Flutter
fish_add_path $HOME/Developer/flutter/bin
set -gx FLUTTER_STORAGE_BASE_URL https://mirrors.tuna.tsinghua.edu.cn/flutter
set -gx PUB_HOSTED_URL https://mirrors.tuna.tsinghua.edu.cn/dart-pub

# Composer
fish_add_path $HOME/.composer/vendor/bin

# Cargo, Rust
fish_add_path $HOME/.cargo/bin

# jenv
set PATH $HOME/.jenv/bin $PATH
status --is-interactive; and source (jenv init -|psub)

# iTerm2
test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Python pdm
if test -n "$PYTHONPATH"
    set -x PYTHONPATH '/opt/homebrew/opt/pdm/libexec/lib/python3.10/site-packages/pdm/pep582' $PYTHONPATH
else
    set -x PYTHONPATH '/opt/homebrew/opt/pdm/libexec/lib/python3.10/site-packages/pdm/pep582'
end

# pnpm
set -gx PNPM_HOME $HOME/Library/pnpm
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

# Bun
set -Ux BUN_INSTALL "$HOME/.bun"
set -px --path PATH "$HOME/.bun/bin"
