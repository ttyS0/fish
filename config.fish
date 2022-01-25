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
      if test -f /usr/local/share/autojump/autojump.fish
        source /usr/local/share/autojump/autojump.fish
      end
  end

end


# Global Variables
set -g fish_color_command d2bfff

# Exported Variables
set -x CEPH_VERSION v16.2.6
set -x GOPATH ~/Code/Go
set -x AWS_REGION us-east-1
set -x AWS_DEFAULT_REGION us-east-1
set -x GPG_TTY (tty) # fix GPG signing with git
set -x OPENFAAS_URL https://gw.skj.dev

