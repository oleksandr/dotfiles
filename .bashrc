#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8^^
export DISABLE_AUTO_TITLE=true

#
# Homebrew setup
#
export HOMEBREW_GITHUB_API_TOKEN="--- put your own ---"

#
# Set my editor and git editor
#
export EDITOR="/usr/local/bin/subl -w"
export GIT_EDITOR='/usr/local/bin/subl -w'

#archey -c

#
# Requires installation of iTerm2 integration
#
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

#
# Requires `brew install bash-completion`
#
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#
# Bash Git prompt settings (https://github.com/magicmonty/bash-git-prompt)
#
# Bash Git Status
# if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
#     # Set config variables first
#     GIT_PROMPT_ONLY_IN_REPO=1
#     # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
#     # GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
#     # GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files
#     # GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files
#     # GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10
#     # GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
#     # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence
#     # as last entry source the gitprompt script
#     GIT_PROMPT_THEME=Default
#     GIT_PROMPT_THEME=Solarized
#     # GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
#     # GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
#     # GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
#     __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
#     source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
# fi

# Virtualenvwrapper for Python
#source /usr/local/bin/virtualenvwrapper.sh

#
# Golang setup
#
if [ -n "$PS1" ]
then
    export GOPATH=$HOME
    export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin
fi
export PATH=$PATH:/usr/local/sbin

# generate fake MAC address
alias fakemac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'"

# spoof ethernet MAC address with FIT's RPi's one
#alias spoofmac_rpi='sudo ifconfig en5 ether b8:27:eb:ff:b3:a5'
#alias spoofmac_octopus='sudo ifconfig en5 ether 00:23:df:df:3a:64'

# tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s $(basename $(pwd))'

# List directory contents
alias ls='ls -G'        # Compact view, show colors
alias la='ls -AF'       # Compact view, show hidden
alias ll='ls -al'
alias l='ls -a'
alias l1='ls -1'
# Get rid of those pesky .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -delete'
# Track who is listening to your iTunes music
alias whotunes='lsof -r 2 -n -P -F n -c iTunes -a -i TCP@`hostname`:3689'
# Flush your dns cache
alias flush='dscacheutil -flushcache'
# Show/hide hidden files (for Mac OS X Mavericks)
alias showhidden="defaults write com.apple.finder AppleShowAllFiles TRUE"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE"
# From http://apple.stackexchange.com/questions/110343/copy-last-command-in-terminal
alias copyLastCmd='fc -ln -1 | awk '\''{$1=$1}1'\'' ORS='\'''\'' | pbcopy'
# Use Finder's Quick Look on a file (^C or space to close)
alias ql='qlmanage -p 2>/dev/null'
# Mute/Unmute the system volume. Plays nice with all other volume settings.
alias mute="osascript -e 'set volume output muted true'"
alias unmute="osascript -e 'set volume output muted false'"
# Pin to the tail of long commands for an audible alert after long processes
## curl http://downloads.com/hugefile.zip; lmk
alias lmk="say 'Process complete.'"

alias map="xargs -n1"

git-search () {
    git log --all -S"$@" --pretty=format:%H | map git show 
}

# Process whiteboarding session images
whiteboard() { convert "$1" -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 "$2"; }

#
# the fuzzy search, you know
#
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#
# tmuxinator specifics
#
_tmuxinator() {
    COMPREPLY=()
    local word
    word="${COMP_WORDS[COMP_CWORD]}"

    if [ "$COMP_CWORD" -eq 1 ]; then
        local commands="$(compgen -W "$(tmuxinator commands)" -- "$word")"
        local projects="$(compgen -W "$(tmuxinator completions start)" -- "$word")"

        COMPREPLY=( $commands $projects )
    elif [ "$COMP_CWORD" -eq 2 ]; then
        local words
        words=("${COMP_WORDS[@]}")
        unset words[0]
        unset words[$COMP_CWORD]
        local completions
        completions=$(tmuxinator completions "${words[@]}")
        COMPREPLY=( $(compgen -W "$completions" -- "$word") )
    fi
}
complete -F _tmuxinator tmuxinator mux
alias mux="tmuxinator"

#
# Powerline for Bash
#
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh



