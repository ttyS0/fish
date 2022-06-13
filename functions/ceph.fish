function ceph --description 'alias ceph=kubectl exec -n rook-ceph deploy/rook-ceph-tools -- ceph'
  kubectl exec -n rook-ceph deploy/rook-ceph-tools -- ceph $argv; 
end
