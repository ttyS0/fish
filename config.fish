if status is-interactive

  if test -x (type -p direnv)
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
set -x CEPH_VERSION v16.2.5
set -x GOPATH ~/Programming/Go
set -x AWS_REGION us-east-1
set -x AWS_DEFAULT_REGION us-east-1
set -x NOMAD_ADDR 'https://nomad.ttys0.net'


# GNUPG
set -x GPG_TTY (tty)
if test -x (type -p gpgconf)
  command gpgconf --launch gpg-agent
end

