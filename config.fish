if status is-interactive
    [ -x (type -p direnv) ]; and direnv hook fish | source

    [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
end


# Global Variables
set -g fish_color_command d2bfff

# Exported Variables
set -x CEPH_VERSION v16.2.5
set -x GOPATH ~/Programming/Go
set -x AWS_REGION us-east-1
set -x AWS_DEFAULT_REGION us-east-1
set -x NOMAD_ADDR 'https://nomad.ttys0.net'
set -x GPG_TTY (tty)

# Aliases
alias k kubectl
alias h helm
alias tf terraform
alias hr 'history --merge'

