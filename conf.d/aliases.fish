
# General

abbr k kubectl
abbr hl helm
abbr tf terraform
abbr hr 'history --merge' # consolidate session histories
abbr h history
abbr .. 'cd ..' # up one
abbr lns 'ln -s' # slightly shorter symlink
abbr less "less -MNi" # file info/position, line #'s, smart case
abbr gr grep
abbr chx 'chmod +x'
abbr chR 'chmod -R'
abbr dut 'du -sch'

# macOS specific
if test (uname | string lower) = "darwin"
  abbr bi 'brew install'
  abbr bu 'brew upgrade'
  abbr bs 'brew search'
  abbr bn 'brew info'
  abbr pbc 'pbcopy'
  abbr pbp 'pbpaste'
  abbr flushdns 'sudo killall -HUP mDNSResponder ;sudo dscacheutil -flushcache'
end

# Linux specific
if test (uname | string lower) = "linux"
  abbr ai 'sudo apt install'
  abbr aup 'sudo apt update; and sudo apt upgrade; and sudo apt autoremove'
end


# Git
abbr g git
abbr gco 'git checkout'
abbr gsw 'git switch'
abbr gcm 'git commit -m'
abbr ga 'git add'
abbr gpl 'git pull'
abbr gph 'git push'
abbr gb 'git branch -a'
abbr gs 'git status'
abbr gplS 'git pull --recurse submodules'
abbr gm 'git merge'

# Docker
abbr d docker
abbr dp 'docker ps'
abbr dpa 'docker ps -a'
abbr db 'docker build'
abbr dbx 'docker buildx build --platform linux/arm64,linux/amd64'
abbr dph 'docker push'
abbr dl 'docker logs'

# URL encode/decode
abbr urlencode 'python -c "import urllib, sys; print urllib.quote_plus(sys.argv[1])"'
abbr urldecode 'python -c "import urllib, sys; print urllib.unquote_plus(sys.argv[1])"'

# Databases
abbr psql 'psql -h pg.ttys0.net -U postgres'
