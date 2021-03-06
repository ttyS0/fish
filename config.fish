if status is-interactive
  if test (uname | string lower) = "darwin"; and test -x (type -p direnv)
    direnv hook fish | source
  end

  switch (uname | string lower)
    case linux
      if test -f /usr/share/autojump/autojump.fish
        source /usr/share/autojump/autojump.fish
      end
    case darwin
      if test -f /opt/homebrew/share/autojump/autojump.fish
        source /opt/homebrew/share/autojump/autojump.fish
      end
      if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
        source /opt/homebrew/opt/asdf/libexec/asdf.fish
      end
  end

end


# Global Variables
set -g fish_color_command d2bfff

# Exported Variables
set -x GOPATH ~/Code/Go
set -x GOROOT /opt/homebrew/opt/go/libexec
set -x AWS_REGION us-east-1
set -x AWS_DEFAULT_REGION us-east-1
set -x GPG_TTY (tty) # fix GPG signing with git
set -x OPENFAAS_URL https://gw.skj.dev
set -x SSH_AUTH_SOCK "/Users/sean/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"


