function rbd -d "Ceph RBD via Docker"
  switch (uname | string lower)
    case darwin
      docker run -it --rm --name rbd -v $HOME/Documents/.dotfiles/ceph:/etc/ceph --entrypoint /usr/bin/rbd ceph/ceph:$CEPH_VERSION $argv
    case linux
      docker run -it --rm --name rbd -v /etc/ceph:/etc/ceph --entrypoint /usr/bin/rbd ceph/ceph:$CEPH_VERSION $argv
  end
end
