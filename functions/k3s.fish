function k3s --wraps='kubectl --kubeconfig=/Users/sean/.kube/locutus' --description 'alias k3s kubectl --kubeconfig=/Users/sean/.kube/locutus'
  kubectl --kubeconfig=/Users/sean/.kube/locutus $argv; 
end
