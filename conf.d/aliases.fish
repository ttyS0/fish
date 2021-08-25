
# General

abbr k kubectl
abbr h helm
abbr tf terraform
abbr hr 'history --merge' # consolidate session histories
abbr .. 'cd ..' # up one
abbr lns 'ln -s' # slightly shorter symlink
abbr less "less -MNi" # file info/position, line #'s, smart case
abbr gr grep

# macOS specific
if test (uname | string lower) = "darwin"
  abbr bi 'brew install'
  abbr bu 'brew upgrade'
  abbr bs 'brew search'
  abbr bn 'brew info'
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

