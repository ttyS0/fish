function ceph -d "Ceph via Docker"
  switch (uname | string lower)
    case darwin
      docker run -it --rm --name ceph -v ~/Documents/.dotfiles/ceph:/etc/ceph --entrypoint /usr/bin/ceph quay.io/ceph/ceph:$CEPH_VERSION $argv
    case linux
      docker run -it --rm --name ceph -v /etc/ceph:/etc/ceph --entrypoint /usr/bin/ceph quay.io/ceph/ceph:$CEPH_VERSION $argv
  end
end

