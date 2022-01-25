function pmm -d "Plex-Meta-Manager"
  if test (uname | string lower) = "darwin"
    nerdctl run -it -v "/Users/sean/Documents/Tools/pmm:/config:rw" meisnate12/plex-meta-manager:latest
  else
    echo "Only intended to be run on my iMac"
  end
end
