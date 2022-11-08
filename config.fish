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

alias os='cd ~/Developer/open-source'

# Git Aliases

# Go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs="git status"
alias gp="git push"
alias gpoh="git push -u origin HEAD"
alias gpf="git push --force"
alias gpft="git push --follow-tags"
alias gpdo="git push --delete origin"
alias gpl="git pull --rebase"
alias gcl="git clone"
alias gst="git stash"
alias gstp="git stash pop"
alias grm='git rm'
alias gmv='git mv'

alias main='git checkout (get_main_branch)'
alias gcd="git checkout dev"

alias gb="git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"

alias gfo='git fetch origin'
alias gfu='git fetch (get_upstream)'
alias gfa='git fetch --all'

alias grb="git rebase"
alias grbom="git rebase origin/(get_main_branch)"
alias grbod="git rebase origin/dev"
alias grbum="git rebase (get_upstream)/(get_main_branch)"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"

alias gl="git log"
alias glo="git log --oneline --graph"

alias grsH="git reset HEAD"
alias grsH1="git reset HEAD~1"
alias grsh="git reset --hard"
alias grsod="git reset --hard origin/dev"
alias grsum="git reset --hard (get_upstream)/(get_main_branch)"

alias ga="git add"
alias gA="git add -A"

alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit -a"
alias gcae="git commit --amend"
alias gcaen="git commit --amend --no-edit -n"
alias regcp="gcaen -a && gpf"
alias gcam="git add -A && git commit -m"
alias gfrb="git fetch (get_upstream) && grbom"
alias gsha="git rev-parse HEAD | tr -d \n | pbcopy"

alias gxn='git clean -dn'
alias gx='git clean -df'

alias gop='git open'

# GitHub Aliases
alias ghci='gh run list -L 1'
alias pr="gh pr checkout"
alias fork="gh repo fork"

# NPM Aliases
alias s="nr start"
alias d="nr dev"
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
alias reni="rm -fr node_modules && ni"

# @sxzz/create
alias cr='create'

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias coder="code -r ."

# Colors
set RED '\e[1;31m'
set GREEN '\e[1;32m'
set YELLOW '\e[1;33m'
set BLUE '\e[1;34m'
set PINK '\e[1;35m'
set SKYBLUE '\e[1;96m'
set RES '\e[0m'

function console.red
    echo -en "$RED$argv$RES"
end

function console.green
    echo -en "$GREEN$argv$RES"
end

function console.yellow
    echo -en "$YELLOW$argv$RES"
end

function console.blue
    echo -en "$BLUE$argv$RES"
end

function console.skyblue
    echo -en "$SKYBLUE$argv$RES"
end
function console.pink
    echo -en "$PINK$argv$RES"
end

function get_main_branch
    if test -f .git/refs/heads/main
        echo main
    else if test -f .git/refs/heads/dev
        echo dev
    else if test -f .git/refs/heads/master
        echo master
    else
        console.red "No main or master branch found\n"
        return 1
    end
end

function get_upstream
    if test -d .git/refs/remotes/upstream
        echo upstream
    else if test -d .git/refs/remotes/origin
        echo origin
    else
        console.red "No main or master branch found\n"
    end
end

# Switch node version (fnm)
function sn
    set versions (fnm ls | awk '{print $2}')
    and set selected (fnm ls | awk '{print $2}' | tail -r | gum filter)
    and fnm use $selected
end

# git branch prune
function gbp
    main

    gum spin --spinner globe --title "Fetching..." -- git remote prune origin
    set _status $status
    if not test $_status -eq 0
        return $_status
    end

    set GONE_BRANCHES (git branch -v | grep -v "^*" | grep "\[gone\]" | awk '{print $1}')
    if not test "$GONE_BRANCHES"
        console.yellow "No gone branches\n"
        return 1
    end

    set DELETE_BRANCHES (gum choose --no-limit --selected=(echo $GONE_BRANCHES | sed -e "s/ /,/g") $GONE_BRANCHES)
    and echo "Delete branches: "
    and console.blue "$DELETE_BRANCHES\n"
    and echo $GONE_BRANCHES | xargs git branch -D
end

function select_branch
    git branch | sed -e "s/^[* ]*//g" | gum filter $argv
end

# Git rebase && push
function grbp
    gum spin --spinner globe --title "Fetching..." -- git fetch --all
    and set SELECTED_BRANCH (select_branch --no-limit)
    for name in $SELECTED_BRANCH
        echo -e "\nProcessing '$BLUE$name$RES' branch..."
        and git checkout $name
        and grbum
        and gpf
        set _status $status
        if not test $_status -eq 0
            return $_status
        end
    end
end

function select_commit
    set LOG (git log --oneline)
    and printf "%s\n" $LOG | sed -e "s/^ //g" | gum filter $argv | awk '{print $1}'
end

function grst
    set COMMIT_ID (select_commit)
    if not test $COMMIT_ID
        return 1
    end
    set COMMAND "git reset $argv $COMMIT_ID"

    and echo -n "Execute: "
    and console.green "$COMMAND\n"
    and eval $COMMAND
end

function grvt
    set COMMIT_ID (select_commit)
    if not test $COMMIT_ID
        return 1
    end
    set COMMAND "git revert $argv $COMMIT_ID"

    and echo -n "Execute: "
    and console.green "$COMMAND\n"
    and eval $COMMAND
end

function gco
    if test $argv
        git checkout $argv
    else
        set SELECTED_BRANCH (select_branch)
        if not test $SELECTED_BRANCH
            return 1
        end
        git checkout $SELECTED_BRANCH
    end
    return $status
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
source $HOME/.iterm2_shell_integration.fish

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

# starship
starship init fish | source
