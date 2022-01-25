function k3s --wraps='kubectl --kubeconfig=/Users/sean/.kube/elrond' --description 'alias k3s kubectl --kubeconfig=/Users/sean/.kube/elrond'
  kubectl --kubeconfig=/Users/sean/.kube/elrond $argv; 
end
